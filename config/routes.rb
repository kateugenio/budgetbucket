Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords' }
  as :user do
    get '/', to: 'users/sessions#new'
  end

  # DashboardController
  get 'dashboard', to: 'dashboard#dashboard'

  # ExternalAccountsController
  post 'metadata', to: 'external_accounts#metadata'
  post 'create_from_service', to: 'external_accounts#create_from_service'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
