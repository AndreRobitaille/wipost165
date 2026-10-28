require "test_helper"
require "minitest/mock"

class PublicInformationTest < ActionDispatch::IntegrationTest
  test "configured Post contact channels remain independent in both editions" do
    %w[v1 v2].each do |edition|
      with_information_settings(edition) do
        [ [ "help@example.org", "+1 (920) 555-0123" ], [ "help@example.org", "" ], [ "", "+1 (920) 555-0123" ], [ "", "" ] ].each do |email, phone|
          Rails.configuration.x.stub(:public_contact_email, email) do
            Rails.configuration.x.stub(:public_contact_phone, phone) do
              %w[/membership /veteran-help].each do |path|
                get path
                assert_response :success
                shows_post_phone = path == "/veteran-help" && phone.present?
                assert_select ".post-contact-links a[href='mailto:help@example.org']", count: email.present? ? 1 : 0
                assert_select ".post-contact-links a[href='tel:+19205550123']", count: shows_post_phone ? 1 : 0
                assert_select ".post-contact-links a", count: (email.present? ? 1 : 0) + (shows_post_phone ? 1 : 0)
                assert_select "a[href='mailto:wipost165@gmail.com']", count: 0
                if path == "/veteran-help"
                  assert_select ".post-crisis a[href='tel:988']", text: "Call 988, then press 1"
                  assert_select ".post-crisis a[href='sms:838255']", count: 1
                  assert_select "a[href='tel:9206834055']", count: 1
                  assert_select ".post-contact-unavailable", count: email.blank? && phone.blank? ? 1 : 0
                else
                  assert_select "a[href^='tel:']", count: 0
                  assert_select ".post-join a[href='/visit']", count: 1
                  assert_select "details, summary", count: 0
                  assert_not_includes response.body, "dues and public contact details are being confirmed"
                end
              end
            end
          end
        end
      end
    end
  end

  test "membership omits the service officer phone while veteran help keeps it" do
    %w[v1 v2].each do |edition|
      with_information_settings(edition) do
        get membership_path
        assert_response :success
        assert_select "a[href^='tel:']", count: 0
        assert_not_includes response.body, "860-7478"
        assert_select "a[href='mailto:wipost165@gmail.com']", count: 1

        get veteran_help_path
        assert_response :success
        assert_select "a[href='tel:9208607478']", text: /860-7478/
        assert_select "a[href='tel:9206834055']", text: "Call 920-683-4055"
        assert_select "a[href='tel:988']", text: "Call 988, then press 1"
        assert_select "a[href='mailto:wipost165@gmail.com']", count: 1
      end
    end
  end

  test "contact page omits the Post phone number in both editions" do
    %w[v1 v2].each do |edition|
      with_information_settings(edition) do
        Rails.configuration.x.stub(:public_contact_email, "wipost165@gmail.com") do
          Rails.configuration.x.stub(:public_contact_phone, "(920) 860-7478") do
            get contact_path
            assert_response :success
            assert_select "a[href^='tel:']", count: 0
            assert_not_includes response.body, "860-7478"
            assert_select "a[href^='mailto:']", minimum: 1
            assert_select "a[href^='mailto:wipost165@gmail.com']", count: 1
            assert_includes response.body, "The Post is run by volunteers. Please allow time for a reply."
            assert_includes response.body, "PO Box 11"
          end
        end
      end
    end
  end

  test "crisis contact is the first service route and membership stays a separate page" do
    %w[v1 v2].each do |edition|
      with_information_settings(edition) do
        get veteran_help_path
        assert_response :success
        assert_select ".post-page > section:first-of-type.post-crisis", count: 1
        assert_select ".post-page a[href='/membership']", count: 0
        assert_select ".post-page a[href='https://www.veteranscrisisline.net/get-help-now/chat/']", count: 1
        assert_select ".post-page", text: /not emergency lines/
      end
    end
  end

  private

  def with_information_settings(edition, &block)
    Rails.configuration.x.stub(:public_site_edition, edition) do
      Rails.configuration.x.stub(:public_site_preview, true, &block)
    end
  end
end
