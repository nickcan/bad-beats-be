Rails.application.routes.draw do
  resources :users, only: [:create, :index, :show] do
    get 'posts', to: 'posts#user_posts'
  end
  post 'auth_user' => 'authentication#authenticate_user'
  get 'active_user', to: 'users#active_user'
  put 'active_user', to: 'users#update'
  delete 'active_user', to: 'users#destroy'

  resources :posts, except: [:edit, :new, :update] do
    resources :comments, only: [:index]
    get 'votes', to: 'votes#votes_per_post'
  end

  resources :comments, only: [:destroy, :create, :update] do
    get 'votes', to: 'votes#votes_per_comment'
  end


  resources :tags, only: [:index]
  resources :images, only: [:create, :show]
  resources :sessions, only: :create
  resources :votes, only: [:create, :destroy]

  get 'tags/:name/posts', to: 'tags#posts_by_tag'
  get 'logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#login_facebook'
end
