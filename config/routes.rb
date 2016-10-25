Rails.application.routes.draw do
  root to: 'home#show'
  resources :requesters, only: [:new, :create]
  resources :professionals, only: [:new, :create, :edit, :update]
  resources :jobs, only: [:show, :new, :edit, :update, :create]

  get '/confirmation', to: 'sessions#confirm'
  post '/validate', to: 'sessions#validate'
  get '/login',     to: 'sessions#new',     as: 'login'
  post '/login',    to: 'sessions#create'
  get '/logout',    to: 'sessions#destroy', as: 'logout'

  namespace :api do
    resources :accounts, only: [:new, :create, :update]
    get 'accounts/dashboard', to: 'accounts#show'

    namespace :v1 do
      namespace :jobs do
        post '/:job_id/message', to: 'messages#create'
        get '/:job_id/messages', to: 'messages#index'
      end
      namespace :oauth do
        get '/token',              to: 'token#create', format: "json"
      end
    end

    namespace :oauth do
      get '/authorize',          to: 'authorize#new'
      post '/authorize',         to: 'authorize#create'
      get '/authorize/confirm',  to: 'authorize#show'
      get '/authorize/redirect', to: 'authorize#redirect'
    end
  end
  namespace :requesters do
    get '/dashboard', to: 'users#show'
    resources :reviews, only: [:show, :create, :new,]
  end

  namespace :professionals do
    get '/dashboard', to: 'users#show'
    resources :jobs, only: [:index]
    resources :messages, only: [:new, :create]

  end

  get '/test_redirect_landing', to: "test_landing#show"


  resources :conversations, only: [:index]
  resources :messages, only: [:index]
end
