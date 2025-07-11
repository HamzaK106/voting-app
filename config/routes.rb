Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Admin routes
  namespace :admin do
    get 'delegation_analytics/index'
    get 'verification_attempts', to: 'verification_attempts#index'
    get 'users', to: 'users#index'
    get 'users/:id/toggle_admin', to: 'users#toggle_admin', as: :toggle_admin_user
    get 'delegation_analytics', to: 'delegation_analytics#index'
    resources :elections do
      resources :candidates, except: [:show]
    end
  end

  # Ranked Choice Voting routes
  resources :elections, only: [:index, :show] do
    member do
      get :results
    end
    resources :ballots, only: [:create]
  end

  # SMS Verification routes
  get 'sms_verification/request', to: 'sms_verification#request_code', as: :request_sms_verification
  get 'sms_verification/verify', to: 'sms_verification#verify', as: :verify_sms_verification
  post 'sms_verification/verify', to: 'sms_verification#verify'

  # Delegation routes
  resource :delegation, only: [:show, :edit, :update]

  # Root route
  root 'home#index'
end
