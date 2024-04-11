Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#google_login'
  get 'auth/failure', to: redirect('/')
  get 'logout', to: 'sessions#logout'

  get "gigs/past" => "gigs#past"
  resources :gigs

  resources :posts
  resources :responses

  get 'profile/index'
  root 'home#index'
end
