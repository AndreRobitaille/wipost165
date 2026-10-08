Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "public_site#home"
  get "people/:id/portrait/:revision/:size.webp", to: "portraits#show", as: :published_portrait,
    constraints: { id: /[A-Za-z0-9_-]+/, revision: /[A-Za-z0-9_-]+/, size: /small|large/ }, format: false
  get "people/:slug", to: "public_site#person", as: :person
  get "events", to: "public_site#events", as: :events
  get "events/:slug", to: "public_site#event", as: :event
  get "visit", to: "public_site#visit", as: :visit
  get "why-the-legion", to: "public_site#why_legion", as: :why_legion
  get "about", to: "public_site#about", as: :about
  get "contact", to: "public_site#contact", as: :contact
  get "membership", to: "public_site#membership", as: :membership
  get "veteran-help", to: "public_site#help", as: :veteran_help
end
