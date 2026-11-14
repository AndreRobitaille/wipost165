class PublicCrawlController < ApplicationController
  layout false

  def robots
    expires_in 1.hour, public: true
    render plain: PublicSiteHelper.robots_txt, content_type: "text/plain"
  end

  def sitemap
    expires_in discovery_cache, public: true
    render plain: PublicDiscovery.sitemap_xml, content_type: "application/xml"
  end

  def llms
    expires_in discovery_cache, public: true
    render plain: PublicDiscovery.llms_txt, content_type: "text/plain"
  end

  private

  def discovery_cache
    Rails.configuration.x.public_site_coming_soon ? 1.hour : 5.minutes
  end
end
