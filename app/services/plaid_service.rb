class PlaidService
  # https://github.com/plaid/plaid-ruby
  require 'plaid'

  def initialize
    @client = Plaid::Client.new(
      env: Rails.application.credentials[Rails.env.to_sym][:plaid_env],
      client_id: Rails.application.credentials[Rails.env.to_sym][:plaid_client_id],
      secret: Rails.application.credentials[Rails.env.to_sym][:plaid_secret],
      public_key: Rails.application.credentials[Rails.env.to_sym][:plaid_public_key]
    )
  end

  # Exchange public_token for access_token
  # public_token expires in 30 minutes
  # plaid.com/docs/#exchange-token-flow
  def token_exchange(public_token)
    response = @client.item.public_token.exchange(public_token)
    { access_token: response['access_token'], item_id: response['item_id'] }
  end

  def account_balance(access_token, account_id)
    response = @client.accounts.balance.get(access_token, { account_ids: [account_id] })
    response[:accounts]
  rescue StandardError => e
    # TODO: Add some error logging
    raise StandardError.new("Bad request")
  end
end
