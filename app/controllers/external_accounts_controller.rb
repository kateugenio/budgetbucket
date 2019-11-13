class ExternalAccountsController < ApplicationController
  before_action :set_user

  # POST /metadata
  def metadata
    respond_to do |format|
      @public_token = params[:public_token]
      @metadata = params[:metadata]

      format.js
    end
  end

  private

  def set_user
    @user = current_user
  end
end
