Rails.application.routes.draw do
  root to: 'videos#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :videos, only: [:index, :show]
end
