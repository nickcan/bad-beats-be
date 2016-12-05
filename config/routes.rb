Rails.application.routes.draw do
  resources :users, except: [:edit, :new] do
    get 'posts', to: 'posts#user_posts'
  end

  resources :posts, except: [:edit, :new, :update] do
    resources :comments, only: [:index]
  end

  resources :comments, only: [:destroy, :create, :update]

  resources :sessions, only: :create
  resources :images, only: [:create, :show]

  get 'logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#login_facebook'
  get 'active_user', to: 'users#active_user'
end
