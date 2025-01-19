Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  resources :users
  post 'login', to: 'users#login'
  
  resources :loans do 
    collection do 
      get :requested_loans
      get :list_of_confirmation_loans
      get :current_user_loans
      get :list_of_addjustment_loans
    end

    member do 
      put :update_confirm_loan
      put :update_addjustment_loan
      put :repay_the_loan
    end
  end
end
