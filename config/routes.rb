Rails.application.routes.draw do
  resources :users do
    resources :posts, only: [:create, :update, :destroy]
  end

  resources :posts, only: [:index, :show]

  resources :sessions, only: :create
  resources :images, only: [:create, :show]

  get 'logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#login_facebook'
  get 'active_user', to: 'users#active_user'
end
