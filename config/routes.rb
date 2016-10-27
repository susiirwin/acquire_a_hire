Rails.application.routes.draw do
  root to: 'home#show'
  resources :requesters, only: [:new, :create]
  resources :professionals, only: [:new, :create, :edit, :update]
  resources :jobs, only: [:show, :new, :edit, :update, :create]
  resources :reviews, only: [:show, :create, :new]
  resources :conversations, only: [:index]
  resources :messages, only: [:index, :new, :create]
  resources :users, only: [:show]

  get '/confirmation', to: 'sessions#confirm'
  post '/validate', to: 'sessions#validate'
  get '/login',     to: 'sessions#new',     as: 'login'
  post '/login',    to: 'sessions#create'
  get '/logout',    to: 'sessions#destroy', as: 'logout'

  namespace :api do
    resources :accounts, only: [:new, :create, :edit, :update]
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
    put '/job_status/:id', to: 'offer#update', as: 'accept_offer'
    delete '/job_status/:id', to: 'offer#destroy', as: 'reject_offer'
  end

  namespace :professionals do
    get '/dashboard', to: 'users#show'
    resources :jobs, only: [:index]
  end

  get '/test_redirect_landing', to: "test_landing#show"
end
