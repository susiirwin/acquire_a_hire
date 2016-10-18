Rails.application.routes.draw do
  root to: 'home#show'

  resources :requesters, only: [:new, :create]
  resources :professionals, only: [:new, :create]
end
