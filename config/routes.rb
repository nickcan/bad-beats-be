Rails.application.routes.draw do
  resources :users

  get '/auth/:provider/callback', to: 'sessions#create'
end
