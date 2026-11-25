class EventCalendarsController < ApplicationController
  def show
    no_store
    response.set_header("X-Robots-Tag", "noindex")
    return head :not_found if Rails.configuration.x.public_site_coming_soon || Rails.configuration.x.public_site_preview

    content = PublicContent.new
    event = content.find_event!(params[:slug])
    return head :not_found unless event.add_to_calendar?

    calendar = EventCalendar.new(event, url: "#{PublicSiteHelper::PUBLIC_ORIGIN}#{event_path(event)}")
    body = calendar.to_ical
    raise Publishing::Unavailable if content.expired?

    filename = event.title.parameterize.first(75).presence || "post-165-event"
    send_data body, filename: "#{filename}.ics", disposition: "inline", type: "text/calendar; charset=utf-8"
  rescue Publishing::NotFound
    head :not_found
  rescue Publishing::Unavailable
    response.set_header("Retry-After", "10")
    head :service_unavailable
  end
end
