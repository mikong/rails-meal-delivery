Rails.application.routes.draw do
  resources :restaurants do
    resources :menu_items, except: [:index, :show]
  end
  resources :employees
  
  resources :user_sessions, only: [:create]
  delete '/logout', to: 'user_sessions#destroy', as: 'logout'
  get '/login', to: 'user_sessions#new', as: 'login'
end
