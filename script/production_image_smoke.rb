require "action_dispatch/testing/integration"
require "nokogiri"
require "json"

def verify!(condition, message)
  raise message unless condition
end

checks = []
%w[v1 v2].each do |edition|
  Rails.configuration.x.public_site_edition = edition
  Rails.configuration.x.public_site_preview = false
  Rails.configuration.x.public_site_coming_soon = false
  Rails.configuration.x.public_site_launch_ready = true
  Rails.configuration.x.public_contact_phone = "+1 (920) 555-0123"
  [ "help@example.test", "" ].each do |email|
    Rails.configuration.x.public_contact_email = email.presence
    request = ActionDispatch::Integration::Session.new(Rails.application)
    request.host! "wipost165.org"
    request.https!
    %w[/membership /contact /veteran-help].each do |path|
      request.get path
      verify!(request.response.status == 200, "#{edition} #{path}: unexpected status")
      html = Nokogiri::HTML(request.response.body)
      main = html.at_css("main")
      verify!(main, "Missing main content")
      if path == "/veteran-help"
        officer = main.at_css('a[href="tel:+19205550123"]')
        verify!(officer&.text&.include?("Call our Service Officer"), "Service Officer phone missing")
      else
        verify!(main.css('a[href^="tel:"]').empty? && !main.text.include?("555-0123"), "Service Officer phone leaked")
      end
      email_links = main.css('a[href="mailto:help@example.test"]')
      verify!(email.present? ? !email_links.empty? : email_links.empty?, "Wrong email availability")
      if path == "/membership"
        verify!(main.at_css(".post-join-contact").present? == email.present?, "Empty membership enquiry")
        verify!(main.at_css('a[href="/visit"]'), "Missing meeting-visit action")
      elsif path == "/contact"
        verify!(main.at_css(".launch-contact-pending, .contact-pending").present? == email.blank?, "Wrong postal fallback")
        verify!(main.text.include?("PO Box 11"), "Missing mailing address")
      end
      checks << { edition: edition, path: path, email_enabled: email.present? }
    end
  end
end
request = ActionDispatch::Integration::Session.new(Rails.application)
request.host! "wipost165.org"
request.https!
request.get "/up"
verify!(request.response.status == 200, "Health check failed")
Rails.configuration.x.public_site_edition = "v1"
request.get "/people/synthetic-check"
verify!(request.response.status == 404, "V1 people route exposed")
asset = Nokogiri::HTML(request.response.body).at_css('link[rel="stylesheet"]')&.[]("href")
verify!(asset.present?, "Compiled stylesheet missing")
request.get asset
verify!(request.response.status == 200 && request.response.body.include?("font-display"), "Compiled stylesheet unavailable")
puts JSON.generate(result: "passed", environment: "isolated production image, no network or credentials", checks: checks)
