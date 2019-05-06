Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords' }
  as :user do
    get '/', to: 'users/sessions#new'
  end

  get 'dashboard', to: 'dashboard#dashboard'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
