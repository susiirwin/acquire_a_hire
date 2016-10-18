Rails.application.routes.draw do
  root to: 'home#show'

  resources :requesters, only: [:new, :create]
  resources :professionals, only: [:new, :create]

  namespace :requesters do
    get '/dashboard', to: 'users#show'
  end

  namespace :professionals do
    get '/dashboard', to: 'users#show'
  end
end
