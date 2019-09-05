Rails.application.routes.draw do
  get 'welcome/index'
  resources :restaurants do
    resources :menu_items, except: [:index, :show]
  end
  resources :employees

  resource :random_lunch, only: [:new]
  post '/random_lunch', to: 'random_lunches#search'
  
  resources :user_sessions, only: [:create]
  delete '/logout', to: 'user_sessions#destroy', as: 'logout'
  get '/login', to: 'user_sessions#new', as: 'login'

  root 'welcome#index'
end
