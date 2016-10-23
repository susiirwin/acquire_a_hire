Rails.application.routes.draw do
  root to: 'home#show'
  resources :requesters, only: [:new, :create]
  resources :professionals, only: [:new, :create, :edit, :update]
  resources :jobs, only: [:show, :new, :create]

  get '/confirmation', to: 'sessions#confirm'
  post '/validate', to: 'sessions#validate'
  get '/login',     to: 'sessions#new',     as: 'login'
  post '/login',    to: 'sessions#create'
  get '/logout',    to: 'sessions#destroy', as: 'logout'

  namespace :api do
    resources :accounts, only: [:new, :create, :update]
    get 'accounts/dashboard', to: 'accounts#show'
  end
  namespace :requesters do
    get '/dashboard', to: 'users#show'
  end

  namespace :professionals do
    get '/dashboard', to: 'users#show'
    resources :jobs, only: [:index]
  end

  namespace :api do
    namespace :v1 do
      namespace :jobs do
        post '/:job_id/message', to: 'messages#create'
        get '/:job_id/messages', to: 'messages#index'
      end
    end
  end
end
