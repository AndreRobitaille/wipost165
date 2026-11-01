require "test_helper"
require "tmpdir"
require "fileutils"
require "open3"
require "json"

class ReleaseSessionTest < ActiveSupport::TestCase
  HEAD = "f" * 40
  DIGEST = "sha256:#{'a' * 64}"
  REPOSITORY = "ghcr.io/andrerobitaille/legion-post-165-wi-public"

  test "failed provisioning and retry share one tunnel until the operator exits" do
    with_release do |root, environment|
      check_output, check_status = command(root, environment, "check")
      assert check_status.success?, check_output
      refute File.exist?("#{root}/events"), "Local check must not open SSH"
      blocked_output, blocked_status = command(root, environment, "setup")
      refute blocked_status.success?, blocked_output
      refute File.exist?("#{root}/events"), "Standalone setup must not open SSH"
      output, status = command(root, environment, "session", "bin/release session\nrelease_setup\nsource lib/release_image.sh\nrelease_ssh hostname </dev/null\nrelease_deploy\nexit\n")
      assert status.success?, output
      events = events(root)
      assert_equal 1, events.count("OPEN"), events.inspect
      assert_equal 1, events.count("CLOSE"), events.inspect
      assert_equal "CLOSE", events.last
      assert events.any? { |event| event.start_with?("KAMAL setup --skip-push") }
      assert events.any? { |event| event.start_with?("KAMAL deploy --skip-push") }
      assert events.any? { |event| event.start_with?("KAMAL build pull") }
      assert_equal 3, events.count("VERIFY"), events.inspect
      assert_includes events, "BOOT"
      assert_includes output, "Production verified at #{HEAD}"
    end
  end

  test "missing or invalid digest cannot fall back to a production build" do
    [ "", "latest", "sha256:wrong" ].each do |digest|
      with_release do |root, environment|
        output, = command(root, environment.merge("RELEASE_IMAGE_DIGEST" => digest), "session", "release_deploy\nexit\n")
        assert_includes output, "must be the verified sha256 digest"
        refute events(root).any? { |event| event.start_with?("KAMAL deploy", "KAMAL build") }
        assert_equal 1, events(root).count("OPEN")
        assert_equal 1, events(root).count("CLOSE")
      end
    end
  end

  test "wrong digest revision service or architecture prevents app replacement" do
    [ [ "digests", [ "#{REPOSITORY}@sha256:#{'b' * 64}" ], "digest mismatch" ],
      [ "labels", { "service" => "another_app", "org.opencontainers.image.revision" => HEAD }, "service mismatch" ],
      [ "labels", { "service" => "legion_post_165_wi_public", "org.opencontainers.image.revision" => "e" * 40 }, "revision mismatch" ],
      [ "architecture", "arm64", "linux/amd64" ] ].each do |key, value, message|
      with_release do |root, environment|
        metadata = image_metadata.merge(key => value)
        output, = command(root, environment.merge("IMAGE_METADATA" => metadata.to_json), "session", "release_deploy\nexit\n")
        assert_includes output, message
        refute events(root).any? { |event| event.start_with?("KAMAL deploy") }
        refute_includes events(root), "BOOT"
        assert_equal 1, events(root).count("OPEN")
      end
    end
  end

  test "pre-deploy hook rejects an image changed by the final pull" do
    with_release do |root, environment|
      changed = image_metadata.merge("digests" => [ "#{REPOSITORY}@sha256:#{'c' * 64}" ])
      output, = command(root, environment.merge("POST_PULL_IMAGE_METADATA" => changed.to_json), "session", "release_deploy\nexit\n")
      assert_includes output, "digest mismatch"
      assert_equal 2, events(root).count("VERIFY")
      refute_includes events(root), "BOOT"
      assert_equal 1, events(root).count("CLOSE")
    end
  end

  test "lost tunnel stops deployment without opening a replacement" do
    with_release do |root, environment|
      output, = command(root, environment, "session", "touch disconnected\nrelease_deploy\nexit\n")
      assert_includes output, "Release tunnel is unavailable"
      refute events(root).any? { |event| event.start_with?("KAMAL deploy", "KAMAL build") }
      assert_equal 1, events(root).count("OPEN")
    end
  end

  test "session Kamal helper selects tunnel configuration without retaining the agent" do
    with_release do |root, environment|
      output, status = command(root, environment, "session", "export SSH_AUTH_SOCK=synthetic-agent\ncd /\nrelease_kamal app details\nexit\n")
      assert status.success?, output
      calls = events(root).grep(/^KAMAL /)
      assert calls.any? { |event| event.match?(%r{\AKAMAL app details -c /tmp/post165-public-release\.[^/]+/deploy\.yml\z}) }, calls.inspect
      assert_includes events(root), "SESSION_CONFIG_VERIFIED"
      assert_includes events(root), "KAMAL_APP_DETAILS_DIRECTORY #{root}"
      assert_equal 1, events(root).count("OPEN")
      assert_equal 1, events(root).count("CLOSE")
      refute_includes output, "Agent leaked"
    end
  end

  test "release shell ignores inherited exit options prompt commands and history file" do
    with_release do |root, environment|
      history = "#{root}/operator-history"
      File.write(history, "existing history\n")
      inherited = environment.merge(
        "SHELLOPTS" => "braceexpand:errexit:hashall",
        "BASHOPTS" => "checkwinsize:cmdhist",
        "PROMPT_COMMAND" => "echo PROMPT_LEAK >> \"$TEST_ROOT/events\"; exit 89",
        "HISTFILE" => history,
        "HISTSIZE" => "1000",
        "HISTFILESIZE" => "1000"
      )
      output, status = command(root, inherited, "session", "echo synthetic-release-secret >/dev/null\nfalse\nrelease_ssh hostname </dev/null\nexit\n")
      assert status.success?, output
      assert_equal "existing history\n", File.read(history)
      refute_includes events(root), "PROMPT_LEAK"
      assert_equal 1, events(root).count("OPEN")
      assert_equal 1, events(root).count("CLOSE")
      assert_equal "CLOSE", events(root).last
    end
  end

  test "session Kamal helper refuses another configuration and a lost master" do
    with_release do |root, environment|
      input = "release_kamal app details --config-file=/tmp/another.yml\ntouch disconnected\nrelease_kamal app details\nexit\n"
      output, = command(root, environment, "session", input)
      assert_includes output, "release_kamal selects the session configuration"
      assert_includes output, "Release tunnel is unavailable"
      refute events(root).any? { |event| event.start_with?("KAMAL app details") }
      assert_equal 1, events(root).count("OPEN")
      assert_equal 1, events(root).count("CLOSE")
    end
  end

  test "Kamal build refusal runs offline before a build can proceed" do
    with_release do |root, environment|
      output, status = Open3.capture2e(environment, "#{root}/.kamal/hooks/pre-build", chdir: root)
      refute status.success?, output
      assert_includes output, "Kamal builds are disabled"
      refute File.exist?("#{root}/events"), "The refusal hook must not contact SSH, Kamal or Docker"
    end
  end

  test "rollback version mismatch stops at the image guard before boot" do
    with_release do |root, environment|
      output, = command(root, environment, "session", "release_kamal rollback #{'e' * 40}\nexit\n")
      assert_includes output, "KAMAL_VERSION must match reviewed HEAD"
      assert_equal 0, events(root).count("VERIFY"), "A different rollback target must fail before inspecting the HEAD image"
      refute_includes events(root), "BOOT"
      assert_equal 1, events(root).count("OPEN")
      assert_equal 1, events(root).count("CLOSE")
    end
  end

  test "image verification cannot run outside the owned session" do
    with_release do |root, environment|
      output, status = command(root, environment, "verify-image")
      refute status.success?, output
      assert_includes output, "requires an active release session"
      refute File.exist?("#{root}/events")
    end
  end

  private

  def image_metadata
    { "digests" => [ "#{REPOSITORY}@#{DIGEST}" ], "os" => "linux", "architecture" => "amd64",
      "labels" => { "service" => "legion_post_165_wi_public", "org.opencontainers.image.revision" => HEAD } }
  end

  def events(root)
    File.readlines("#{root}/events", chomp: true)
  end

  def command(root, environment, action, input = "")
    Open3.capture2e(environment, "bash", "#{root}/bin/release", action, stdin_data: input)
  end

  def with_release
    Dir.mktmpdir("release-session-test") do |root|
      %w[bin lib config fake .kamal/hooks script].each { |path| FileUtils.mkdir_p("#{root}/#{path}") }
      %w[bin/release bin/publish-image lib/release_image.sh config/deploy.yml .kamal/hooks/pre-build .kamal/hooks/pre-deploy script/build_production_image].each do |path|
        FileUtils.cp(Rails.root.join(path), "#{root}/#{path}")
      end
      File.write("#{root}/identity", "test-only")
      File.write("#{root}/ssh-config", "")
      fake = <<~'SH'
        #!/usr/bin/env bash
        case "${0##*/}" in
          ssh)
            case " $* " in
              *" -G "*) printf 'identityfile %s/identity\n' "$TEST_ROOT" ;;
              *" ControlMaster=yes "*) echo OPEN >> "$TEST_ROOT/events" ;;
              *" -O exit "*) echo CLOSE >> "$TEST_ROOT/events" ;;
              *" -O check "*) [[ ! -f "$TEST_ROOT/disconnected" ]] ;;
              *"docker image inspect"*) echo VERIFY >> "$TEST_ROOT/events"; printf '%s\n' "$IMAGE_METADATA" ;;
              *"legion_post_165_wi_tools"*) printf '%s\n' 'aaa legion_post_165_wi_tools-web-old' 'bbb two_rivers_reporter-web-old' ;;
              *"label=service=legion_post_165_wi_public"*) echo "legion_post_165_wi_public-web-$TEST_HEAD" ;;
              *) echo SSH >> "$TEST_ROOT/events" ;;
            esac ;;
          git)
            case "$1" in
              symbolic-ref) echo codex/test ;;
              rev-parse) echo "$TEST_HEAD" ;;
              ls-remote) printf '%s\trefs/heads/codex/test\n' "$TEST_HEAD" ;;
            esac ;;
          ruby)
            [[ "$1" != -rsocket ]] || exit 0
            exec "$TEST_RUBY" "$@" ;;
          socat) exit 0 ;;
          timeout) shift 2; exec "$@" ;;
          publisher-check) echo PUBLISHER_READ >> "$TEST_ROOT/events" ;;
          kamal)
            echo "KAMAL $*" >> "$TEST_ROOT/events"
            [[ -z "${SSH_AUTH_SOCK:-}" ]] || { echo "Agent leaked" >&2; exit 1; }
            [[ "$1 $2" != "app details" ]] || echo "KAMAL_APP_DETAILS_DIRECTORY $PWD" >> "$TEST_ROOT/events"
            if [[ "$1" == config ]]; then
              "$TEST_RUBY" -ryaml -e '
                config = YAML.safe_load_file(ARGV[0])
                abort "Remote builder selected" if config.dig("builder", "remote")
                abort "Wrong tunnel" unless config.dig("ssh", "proxy_command") == "socat - TCP:127.0.0.1:#{ENV.fetch("RELEASE_TUNNEL_PORT")}"
                abort "Wrong identity" unless config.dig("ssh", "keys") == [ ENV.fetch("RELEASE_IDENTITY_FILE") ]
              ' "${@: -1}" || exit "$?"
              echo SESSION_CONFIG_VERIFIED >> "$TEST_ROOT/events"
            fi
            [[ "$1" != setup ]] || exit 1
            if [[ "$1" == deploy || "$1" == rollback ]]; then
              export KAMAL_VERSION="$TEST_HEAD"
              [[ "$1" != rollback ]] || export KAMAL_VERSION="$2"
              [[ -z "${POST_PULL_IMAGE_METADATA:-}" ]] || export IMAGE_METADATA="$POST_PULL_IMAGE_METADATA"
              .kamal/hooks/pre-deploy || exit "$?"
              echo BOOT >> "$TEST_ROOT/events"
            fi ;;
        esac
      SH
      %w[ssh git ruby socat curl timeout].each do |name|
        File.write("#{root}/fake/#{name}", name == "curl" ? "#!/usr/bin/env bash\nprintf 200\n" : fake)
        File.chmod(0o755, "#{root}/fake/#{name}")
      end
      %w[kamal publisher-check].each do |name|
        File.write("#{root}/bin/#{name}", fake)
        File.chmod(0o755, "#{root}/bin/#{name}")
      end
      environment = {
        "PATH" => "#{root}/fake:#{ENV.fetch('PATH')}", "TEST_ROOT" => root, "TEST_HEAD" => HEAD,
        "TEST_RUBY" => RbConfig.ruby, "IMAGE_METADATA" => image_metadata.to_json,
        "RELEASE_SSH_CONFIG" => "#{root}/ssh-config", "RELEASE_IMAGE_DIGEST" => DIGEST,
        "KAMAL_REGISTRY_PASSWORD" => "test-only", "POST165_PUBLIC_SECRET_KEY_BASE" => "test-only"
      }
      yield root, environment
    end
  end
end
