Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#google_login'
  get 'auth/failure', to: redirect('/')
  get 'logout', to: 'sessions#logout'

  get 'gigs/index'
  get 'profile/index'
  root 'home#index'
end
