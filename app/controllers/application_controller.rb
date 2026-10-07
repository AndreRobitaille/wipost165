class ApplicationController < ActionController::Base
  helper_method :public_site_v1?

  private

  def public_site_v1?
    Rails.configuration.x.public_site_edition == "v1"
  end

  def public_site_released?
    Rails.configuration.x.public_site_launch_ready &&
      !Rails.configuration.x.public_site_preview && !Rails.configuration.x.public_site_coming_soon
  end
end
