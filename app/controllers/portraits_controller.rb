class PortraitsController < ApplicationController
  def show
    response.set_header("Cache-Control", "no-store")
    return head :not_found if Rails.configuration.x.public_site_coming_soon

    client = Publishing::Client.new
    body = client.portrait(id: params[:id], revision: params[:revision], size: params[:size])
    raise Publishing::Unavailable, "Portrait expired" if client.expired?

    send_data body, type: "image/webp", disposition: "inline"
    response.set_header("Cache-Control", "no-store")
  rescue Publishing::NotFound
    head :not_found
  rescue Publishing::Unavailable
    response.set_header("Retry-After", "10")
    head :service_unavailable
  end
end
