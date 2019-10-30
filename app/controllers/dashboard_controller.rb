class DashboardController < ApplicationController
  before_action :set_user

  def dashboard; end

  private

  def set_user
    @user = current_user
  end
end
