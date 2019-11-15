class ExternalAccountsController < ApplicationController
  before_action :set_user

  # POST /metadata
  def metadata
    respond_to do |format|
      @account = @user.accounts.new
      public_token = params[:public_token]
      @institution_name = params[:metadata][:institution][:name]
      depository_accounts = params[:metadata][:accounts].select { |key, account| account[:type] == 'depository' }
      @accounts = []
      depository_accounts.each_pair do |_key, account|
        @accounts << {
          id: account['id'],
          name: account['name'],
          mask: account['mask'],
          subtype: account['subtype']
        }
      end

      fetch_plaid_access_token_and_cache_token_and_accounts(public_token, @accounts)

      format.js
    end
  end

  def create_from_service
    puts params.inspect
  end

  private

  def set_user
    @user = current_user
  end

  def fetch_plaid_access_token_and_cache_token_and_accounts(public_token, accounts)
    plaid_service = PlaidService.new
    response = plaid_service.token_exchange(public_token)
    cache_metadata(response[:access_token], response[:item_id], accounts)
  end

  def cache_metadata(access_token, item_id, accounts)
    Rails.cache.fetch("/users/#{@user.id}/external_accounts") do
      { access_token: access_token, accounts: accounts }
    end

    cache = Rails.cache.fetch("/users/#{@user.id}/external_accounts")
  end
end
