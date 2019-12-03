class AccountsController < ApplicationController
  before_action :set_user

  # POST /accounts/metadata
  # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
  def metadata
    Rails.cache.delete("/users/#{@user.id}/external_accounts")

    respond_to do |format|
      @account = @user.accounts.new
      public_token = params[:public_token]
      @institution_name = params[:metadata][:institution][:name]
      depository_accounts = params[:metadata][:accounts].select { |_key, account|
        account[:type] == 'depository'
      }
      @accounts = []
      depository_accounts.each_pair do |_key, account|
        @accounts << {
          id: account['id'],
          name: account['name'],
          mask: account['mask'],
          subtype: account['subtype']
        }
      end

      fetch_plaid_access_token_and_cache_token_and_accounts(public_token, @institution_name,
                                                            @accounts)

      format.js
    end
  end
  # rubocop: enable Metrics/AbcSize, Metrics/MethodLength

  # POST /accounts/create_from_service
  def create_from_service
    @account = @user.accounts.new(account_params)
    @account.update_with_cached_metadata
    if @account.save
      redirect_to dashboard_path
    else
      # TODO: Add flash error here
      render 'dashboard/dashboard'
    end
  end

  # GET /accounts/:id
  def show
    @account = @user.accounts.find(params[:id])
  end

  # GET /accounts/:id/balance
  # rubocop: disable Metrics/AbcSize
  def fetch_balance_from_service
    @account = @user.accounts.find(params[:id])
    respond_to do |format|
      @response = PlaidService.new.account_balance(@account.access_token, @account.account_id)
      balance = @response[0][:balances][:available]
      @account.update(balance: balance, balance_as_of_date: DateTime.current)
      format.js
    end
  end
  # rubocop: enable Metrics/AbcSize

  private

  def account_params
    params.require(:account).permit(
      :account_id
    )
  end

  def set_user
    @user = current_user
  end

  def fetch_plaid_access_token_and_cache_token_and_accounts(public_token, institution_name,
                                                            accounts)
    plaid_service = PlaidService.new
    response = plaid_service.token_exchange(public_token)
    cache_metadata(response[:access_token], response[:item_id], institution_name, accounts)
  end

  def cache_metadata(access_token, item_id, institution_name, accounts)
    Rails.cache.fetch("/users/#{@user.id}/external_accounts") do
      { access_token: access_token, institution_name: institution_name, accounts: accounts }
    end
  end
end
