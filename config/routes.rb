Rails.application.routes.draw do


  post 'confirm', to: 'users/confirmations#confirm'
  post 'verify_otp', to: 'users/confirmations#verify_otp'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    
  }
  
  resources :workspaces do
    resources :tasks
    resources :categories, only: [:index, :create, :update, :destroy]
    member do
      post :add_team_member
      
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
