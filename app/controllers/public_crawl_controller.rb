class PublicCrawlController < ApplicationController
  layout false

  def robots
    expires_in 1.hour, public: true
    render plain: PublicSiteHelper.robots_txt, content_type: "text/plain"
  end

  def sitemap
    expires_in 1.hour, public: true
    render plain: PublicSiteHelper.sitemap_xml, content_type: "application/xml"
  end
end
