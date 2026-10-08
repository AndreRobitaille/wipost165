class PublicSiteController < ApplicationController
  layout -> { public_site_v1? ? "public_site_v1" : "application" }
  before_action :set_public_headers
  before_action :show_coming_soon
  before_action :hide_people_for_v1, only: :person
  before_action :load_public_content
  after_action :discard_expired_content
  after_action :set_indexing_header
  rescue_from Publishing::NotFound, with: :not_found
  rescue_from Publishing::Unavailable, with: :unavailable
  helper_method :preview_mode?, :public_page_indexable?, :public_content_unavailable?

  def home
    return unless public_site_v1?

    @next_event = @content.events.find(&:upcoming?)
    render :home_v1
  end

  def person
    @profile = @content.find_person(params[:slug]) || raise(Publishing::NotFound)
    @remembered_person = @profile
  end

  def events
    @events = @content.events
    render :events_v1 if public_site_v1?
  end

  def event
    @event = @content.find_event!(params[:slug])
    return unless public_site_v1?

    if event_modal_request?
      render :event_modal, layout: false
    else
      render :event_v1
    end
  end

  def visit
    render :visit_v1 if public_site_v1?
  end

  def about; end
  def why_legion; end

  def contact
    render :contact_v1 if public_site_v1?
  end

  def membership; end
  def help; end

  private

  def set_public_headers
    response.set_header("Cache-Control", "no-store")
    set_indexing_header
  end

  def public_page_indexable?
    public_site_released? && @page_error.nil? && !public_content_unavailable?
  end

  def public_content_unavailable?
    (action_name == "home" && (public_site_v1? ? @content&.events_unavailable : @content&.people_unavailable)) ||
      (action_name == "events" && @content&.events_unavailable) || @content&.expired?
  end

  def set_indexing_header
    response.set_header("X-Robots-Tag", "noindex, nofollow, nosnippet, noimageindex") unless public_page_indexable?
  end

  def show_coming_soon
    return unless Rails.configuration.x.public_site_coming_soon

    render :coming_soon, layout: false
  end

  def discard_expired_content
    return unless @content&.expired?

    @people = []
    @remembered_person = nil
    @profile = nil
    @event = nil
    @page_error = :unavailable
    self.response_body = if event_modal_request?
      render_to_string(:event_modal_error, layout: false)
    else
      render_to_string(:unavailable)
    end
    response.status = :service_unavailable
    response.set_header("Retry-After", "10")
  end

  def preview_mode?
    Rails.configuration.x.public_site_preview
  end

  def load_public_content
    @content = PublicContent.new(preview: preview_mode?)
    @people = []
    return if public_site_v1?

    @people = @content.people
    @remembered_person = remembered_person
  end

  def hide_people_for_v1
    return unless public_site_v1?

    not_found
  end

  def remembered_person
    @content.find_person(params[:person])
  rescue Publishing::Unavailable
    nil # Optional recognition never prevents reading static visit/contact information.
  end

  def not_found
    @page_error = :not_found
    set_indexing_header
    render_public_error(:not_found, status: :not_found)
  end

  def unavailable
    @page_error = :unavailable
    set_indexing_header
    response.set_header("Retry-After", "10")
    render_public_error(:unavailable, status: :service_unavailable)
  end

  def event_modal_request?
    public_site_v1? && action_name == "event" && turbo_frame_request_id == "event-details"
  end

  def render_public_error(template, status:)
    if event_modal_request?
      render :event_modal_error, layout: false, status: status
    else
      render template, status: status
    end
  end
end
