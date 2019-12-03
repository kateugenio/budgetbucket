class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  # Overrides default devise after sign in path
  def after_sign_in_path_for(_user)
    dashboard_path
  end
end
