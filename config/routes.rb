Rails.application.routes.draw do
  get "auth/:provider/callback", to: "sessions#google_login"
  get "auth/failure", to: redirect("/")
  get "logout", to: "sessions#logout"

  get "gigs/past", to: "gigs#past"
  resources :gigs

  resources :posts
  resources :responses

  get "feed", to: "feed#index"
  get "profile", to: "profile#index"

  root "login#index"
end
