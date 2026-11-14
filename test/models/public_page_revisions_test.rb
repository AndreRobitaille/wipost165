require "test_helper"

class PublicPageRevisionsTest < ActiveSupport::TestCase
  test "recorded template revisions match the latest git commit of each page" do
    skip "git history is unavailable" unless PublicPageRevisions.git_repository?

    %w[v1 v2].each do |edition|
      PublicPageRevisions::PAGES.fetch(edition).each_key do |path|
        files = PublicPageRevisions.files_for(edition, path)
        assert_equal PublicPageRevisions.git_time(files).utc.iso8601,
          PublicPageRevisions::SNAPSHOT.dig(edition, path),
          "#{edition} #{path}"
      end
    end

    coming_soon = PublicPageRevisions.files_for("coming_soon")
    assert_equal PublicPageRevisions.git_time(coming_soon).utc.iso8601,
      PublicPageRevisions::SNAPSHOT.fetch("coming_soon")
  end
end
