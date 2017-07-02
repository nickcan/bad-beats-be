Rails.application.routes.draw do
  resources :users, only: [:create, :index, :show] do
    get 'posts', to: 'posts#user_posts'
    get 'followers', to: 'users#followers'
    get 'following', to: 'users#following'
  end
  post 'auth_user' => 'authentication#authenticate_user'
  get 'active_user', to: 'users#active_user'
  put 'active_user', to: 'users#update'
  delete 'active_user', to: 'users#destroy'

  resources :comments, only: [:destroy, :create, :update] do
    get 'votes', to: 'votes#votes_per_comment'
  end

  resources :followings, except: [:delete, :edit, :new, :update]
  delete 'followings', to: 'followings#destroy'

  resources :posts, except: [:edit, :new, :update] do
    resources :comments, only: [:index]
    get 'votes', to: 'votes#votes_per_post'
  end

  resources :tags, only: [:index]
  get 'tags/:name/posts', to: 'tags#posts_by_tag'

  resources :images, only: [:create, :show]
  resources :votes, only: [:create]
  delete 'votes', to: 'votes#destroy'

  get '/auth/:provider/callback', to: 'authentication#login_facebook'
end
