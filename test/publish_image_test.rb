require "test_helper"
require "tmpdir"
require "fileutils"
require "open3"
require "digest"

class PublishImageTest < ActiveSupport::TestCase
  HEAD = "f" * 40
  DIGEST = "sha256:#{'a' * 64}"

  test "verified artifact publishes without Docker or persistent credentials" do
    with_artifact do |root, environment|
      output, status = publish(root, environment)
      assert status.success?, output
      assert_includes output, "RELEASE_IMAGE_DIGEST=#{DIGEST}"
      refute_includes output, "test-only-token"
      events = File.readlines("#{root}/calls", chomp: true)
      assert events.any? { |line| line.include?("push ") && line.include?(":#{HEAD}") }
      auth = events.find { |line| line.start_with?("auth ") }
      assert auth
      refute File.exist?(auth.delete_prefix("auth ")), "Temporary registry credentials must be removed"
    end
  end

  test "failed wrong-revision and pull-request workflows cannot publish" do
    [ { "conclusion" => "failure" }, { "head_sha" => "e" * 40 }, { "event" => "pull_request" },
      { "path" => ".github/workflows/another.yml" } ].each do |change|
      with_artifact do |root, environment|
        output, status = publish(root, environment.merge("TEST_RUN" => workflow.merge(change).to_json))
        refute status.success?, output
        refute File.exist?("#{root}/calls"), "Invalid runs must stop before registry access"
      end
    end
  end

  test "corrupt archive stops before registry login" do
    with_artifact do |root, environment|
      File.write("#{root}/artifact/image.tar.gz", "corrupted")
      output, status = publish(root, environment)
      refute status.success?, output
      assert_includes output, "FAILED"
      refute File.exist?("#{root}/calls")
    end
  end

  test "image build command refuses workstation and remote Docker contexts" do
    output, status = Open3.capture2e({ "GITHUB_ACTIONS" => "", "DOCKER_HOST" => "" }, "bash", Rails.root.join("script/build_production_image").to_s, "HEAD", "/tmp/not-created-post165")
    refute status.success?, output
    assert_includes output, "isolated GitHub Actions runner"
    output, status = Open3.capture2e({ "GITHUB_ACTIONS" => "true", "DOCKER_HOST" => "ssh://production.invalid" }, "bash", Rails.root.join("script/build_production_image").to_s, "HEAD", "/tmp/not-created-post165")
    refute status.success?, output
    assert_includes output, "remote Docker host is not allowed"
  end

  private

  def workflow
    { "status" => "completed", "conclusion" => "success", "head_sha" => HEAD,
      "path" => ".github/workflows/production_image.yml", "event" => "push" }
  end

  def publish(root, environment)
    Open3.capture2e(environment, "bash", "#{root}/bin/publish-image", "123")
  end

  def with_artifact
    Dir.mktmpdir("publish-image-test") do |root|
      %w[bin fake artifact].each { |path| FileUtils.mkdir_p("#{root}/#{path}") }
      FileUtils.cp(Rails.root.join("bin/publish-image"), "#{root}/bin/publish-image")
      File.write("#{root}/artifact/image.tar.gz", "synthetic archive")
      File.write("#{root}/artifact/revision.txt", "#{HEAD}\n")
      checksums = %w[image.tar.gz revision.txt].map { |name| "#{Digest::SHA256.file("#{root}/artifact/#{name}").hexdigest}  #{name}" }
      File.write("#{root}/artifact/SHA256SUMS", checksums.join("\n") + "\n")
      stub(root, "git", 'puts ENV.fetch("TEST_HEAD")')
      stub(root, "docker", 'abort "Docker must not be used"')
      stub(root, "gh", <<~'RUBY')
        require "fileutils"
        case ARGV.first
        when "api"
          puts ARGV[1] == "user" ? "synthetic-publisher" : ENV.fetch("TEST_RUN")
        when "run"
          target = ARGV[ARGV.index("--dir") + 1]
          FileUtils.cp(Dir["#{ENV.fetch('TEST_ROOT')}/artifact/*"], target)
        when "auth"
          puts "test-only-token"
        end
      RUBY
      stub(root, "crane", <<~'RUBY')
        require "json"
        File.open("#{ENV.fetch('TEST_ROOT')}/calls", "a") do |log|
          log.puts ARGV.first == "auth" ? "auth #{ENV.fetch('DOCKER_CONFIG')}" : ARGV.join(" ")
        end
        case ARGV.first
        when "auth" then STDIN.read
        when "digest" then puts ENV.fetch("TEST_DIGEST")
        when "config"
          puts JSON.generate("os" => "linux", "architecture" => "amd64", "config" => { "Labels" => {
            "service" => "legion_post_165_wi_public", "org.opencontainers.image.revision" => ENV.fetch("TEST_HEAD") } })
        end
      RUBY
      environment = { "PATH" => "#{root}/fake:#{ENV.fetch('PATH')}", "CRANE" => "#{root}/fake/crane",
        "TEST_ROOT" => root, "TEST_HEAD" => HEAD, "TEST_DIGEST" => DIGEST, "TEST_RUN" => workflow.to_json }
      yield root, environment
    end
  end

  def stub(root, name, code)
    File.write("#{root}/fake/#{name}", "#!#{RbConfig.ruby}\n#{code}\n")
    File.chmod(0o755, "#{root}/fake/#{name}")
  end
end
