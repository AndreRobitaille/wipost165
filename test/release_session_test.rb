require "test_helper"
require "tmpdir"
require "fileutils"
require "open3"

class ReleaseSessionTest < ActiveSupport::TestCase
  test "failed provisioning and retry share one tunnel until the operator exits" do
    Dir.mktmpdir("release-session-test") do |root|
      FileUtils.mkdir_p([ "#{root}/bin", "#{root}/fake" ])
      FileUtils.cp(Rails.root.join("bin/release"), "#{root}/bin/release")
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
              *" -O check "*) exit 0 ;;
              *"legion_post_165_wi_tools"*) printf '%s\n' 'aaa legion_post_165_wi_tools-web-old' 'bbb two_rivers_reporter-web-old' ;;
              *"label=service=legion_post_165_wi_public"*) echo legion_post_165_wi_public-web-testsha ;;
              *) echo SSH >> "$TEST_ROOT/events" ;;
            esac ;;
          git)
            case "$1" in
              symbolic-ref) echo codex/test ;;
              rev-parse) echo testsha ;;
              ls-remote) printf 'testsha\trefs/heads/codex/test\n' ;;
            esac ;;
          ruby|socat) exit 0 ;;
          curl) printf 200 ;;
          timeout) shift 2; exec "$@" ;;
          kamal)
            echo "KAMAL $1" >> "$TEST_ROOT/events"
            [[ "$1" != setup ]] ;;
        esac
      SH
      %w[ssh git ruby socat curl timeout].each do |name|
        File.write("#{root}/fake/#{name}", fake)
        File.chmod(0o755, "#{root}/fake/#{name}")
      end
      File.write("#{root}/bin/kamal", fake)
      File.chmod(0o755, "#{root}/bin/kamal")
      environment = {
        "PATH" => "#{root}/fake:#{ENV.fetch('PATH')}", "TEST_ROOT" => root,
        "RELEASE_SSH_CONFIG" => "#{root}/ssh-config",
        "KAMAL_REGISTRY_PASSWORD" => "test-only", "POST165_PUBLIC_SECRET_KEY_BASE" => "test-only"
      }
      check_output, check_status = Open3.capture2e(environment, "bash", "#{root}/bin/release", "check")
      assert check_status.success?, check_output
      refute File.exist?("#{root}/events"), "Local check must not open SSH"
      blocked_output, blocked_status = Open3.capture2e(environment, "bash", "#{root}/bin/release", "setup")
      refute blocked_status.success?, blocked_output
      refute File.exist?("#{root}/events"), "Standalone setup must not open SSH"
      output, status = Open3.capture2e(environment, "bash", "#{root}/bin/release", "session",
        stdin_data: "release_setup\nrelease_ssh hostname\nrelease_deploy\nexit\n")
      assert status.success?, output
      events = File.readlines("#{root}/events", chomp: true)
      assert_equal 1, events.count("OPEN"), events.inspect
      assert_equal 1, events.count("CLOSE"), events.inspect
      assert_equal "CLOSE", events.last
      assert_operator events.index("KAMAL setup"), :<, events.index("KAMAL deploy")
      assert_includes output, "Production verified at testsha"
    end
  end
end
