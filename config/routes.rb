Rails.application.routes.draw do
  root to: 'home#show'
  resources :requesters, only: [:new, :create]
  resources :professionals, only: [:new, :create, :edit, :update]
  resources :jobs, only: [:new]

  get '/confirmation', to: 'sessions#confirm'
  post '/validate', to: 'sessions#validate'
  get '/login',     to: 'sessions#new',     as: 'login'
  post '/login',    to: 'sessions#create'
  get '/logout',    to: 'sessions#destroy', as: 'logout'

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
        post '/:job_id/new_message', to: 'messages#create'
      end
    end
  end
end
