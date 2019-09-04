Rails.application.routes.draw do
  resources :restaurants
  
  resources :user_sessions, only: [:create]
  delete '/logout', to: 'user_sessions#destroy', as: 'logout'
  get '/login', to: 'user_sessions#new', as: 'login'
end
