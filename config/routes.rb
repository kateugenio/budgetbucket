Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords' }
  as :user do
    get '/', to: 'users/sessions#new'
  end

  # DashboardController
  get 'dashboard', to: 'dashboard#dashboard'

  # AccountsController / BucketsController
  resources :accounts, only: :show do
    resources :buckets do
      patch 'balance', to: 'buckets#update_balance'
    end
  end
  scope :accounts do
    post 'metadata', to: 'accounts#metadata'
    post 'create_from_service', to: 'accounts#create_from_service'
    get ':id/balance', to: 'accounts#fetch_balance_from_service', as: :accounts_fetch_balance
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
