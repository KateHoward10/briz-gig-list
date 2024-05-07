Rails.application.routes.draw do
  get "auth/:provider/callback", to: "sessions#google_login"
  get "auth/failure", to: redirect("/")
  get "logout", to: "sessions#logout"

  get "gigs/past", to: "gigs#past"
  resources :gigs, except: :destroy do
    resources :links
    resources :posts
    resources :reactions
  end

  resources :responses
  resources :venues, only: [:index, :show]

  get "calendar", to: "calendar#index"
  get "profile", to: "profile#index"

  root "feed#index"
  get "login", to: "login#index"
end
