Rails.application.routes.draw do
  root to: 'home#show'

  resources :requesters, only: [:new, :create]
  resources :professionals, only: [:new, :create]

  namespace :requesters do
    get '/login',     to: 'sessions#new',    as: 'login'
    post '/login',    to: 'sessions#create'
    delete '/login',  to: 'sessions#destroy', as: 'destroy_login'
    get '/dashboard', to: 'users#show'
  end

  namespace :professionals do
    get '/dashboard', to: 'users#show'
  end
end
