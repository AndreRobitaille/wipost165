class PublicSiteController < ApplicationController
  before_action :show_coming_soon
  before_action :load_public_content
  after_action :discard_expired_content
  rescue_from Publishing::NotFound, with: :not_found
  rescue_from Publishing::Unavailable, with: :unavailable
  helper_method :preview_mode?

  def home; end

  def person
    @profile = @content.find_person(params[:slug]) || raise(Publishing::NotFound)
    @remembered_person = @profile
  end

  def events
    @events = @content.events
  end

  def event
    @event = @content.find_event!(params[:slug])
  end

  def visit; end
  def about; end
  def contact; end
  def membership; end
  def help; end

  private

  def show_coming_soon
    return unless Rails.configuration.x.public_site_coming_soon

    response.set_header("Cache-Control", "no-store")
    render :coming_soon, layout: false
  end

  def discard_expired_content
    return unless @content&.expired?

    @people = []
    @remembered_person = nil
    @profile = nil
    @event = nil
    self.response_body = render_to_string(:unavailable)
    response.status = :service_unavailable
    response.set_header("Retry-After", "10")
  end

  def preview_mode?
    Rails.configuration.x.public_site_preview
  end

  def load_public_content
    response.set_header("Cache-Control", "no-store")
    response.set_header("X-Robots-Tag", "noindex, nofollow") if preview_mode?
    @content = PublicContent.new(preview: preview_mode?)
    @people = @content.people
    @remembered_person = remembered_person
  end

  def remembered_person
    @content.find_person(params[:person])
  rescue Publishing::Unavailable
    nil # Optional recognition never prevents reading static visit/contact information.
  end

  def not_found
    render :not_found, status: :not_found
  end

  def unavailable
    response.set_header("Retry-After", "10")
    render :unavailable, status: :service_unavailable
  end
end
