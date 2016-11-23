Rails.application.routes.draw do
  resources :users
  resources :sessions, only: :create

  get 'logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#login_facebook'
  get 'active_user', to: 'users#active_user'
end
