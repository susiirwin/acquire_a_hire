Rails.application.routes.draw do
  root to: 'home#show'
  resources :requesters, only: [:new, :create]
  resources :professionals, only: [:new, :create, :edit, :update]

  get '/confirmation', to: 'sessions#confirm'
  post '/validate', to: 'sessions#validate'


  namespace :requesters do
    get '/login',     to: 'sessions#new',     as: 'login'
    post '/login',    to: 'sessions#create'
    get '/logout',    to: 'sessions#destroy', as: 'logout'
    get '/dashboard', to: 'users#show'
  end

  namespace :professionals do
    get '/login',     to: 'sessions#new',     as: 'login'
    post '/login',    to: 'sessions#create'
    get '/logout',    to: 'sessions#destroy', as: 'logout'
    get '/dashboard', to: 'users#show'
    resources :jobs, only: [:index]
  end
end
