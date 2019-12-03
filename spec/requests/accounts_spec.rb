require 'rails_helper'

RSpec.describe 'Accounts', type: :request do
  let(:user) { create(:user) }

  before {
    sign_in user
  }

  let(:external_accounts) { plaid_link_metadata }
  let(:account) { create(:account) }

  it 'sends plaid metadata and renders account information' do
    # Assume
    allow_any_instance_of(PlaidService).to receive(:token_exchange)
      .and_return(access_token: external_accounts[:public_token],
                  item_id: external_accounts[:item_id])

    # Act
    post metadata_path(public_token: external_accounts[:public_token],
                       metadata: external_accounts[:metadata]), xhr: true

    # Assert
    expect(response).to be_successful
  end

  describe '#create' do
    it 'is successful' do
      # Arrange
      accounts_before = user.accounts.count
      cached_accounts = []
      accounts_from_service = plaid_link_metadata[:metadata][:accounts]
      accounts_from_service.each { |_k, v| cached_accounts << v }
      expect(Rails.cache).to receive(:fetch)
        .with("/users/#{user.id}/external_accounts")
        .and_return(access_token: 333, institution_name: 'Bank of America',
                    accounts: cached_accounts)

      # Act
      post create_from_service_path(params: { account: { account_id: cached_accounts[0][:id] } })

      # Assert
      expect(response).to redirect_to(dashboard_path)
      expect(user.accounts.count).to eq accounts_before + 1
    end
  end

  it 'renders show' do
    # Act
    get account_path(account)

    # Assert
    expect(response).to be_successful
    expect(response).to render_template('show')
  end

  it 'fetches account balance' do
    # Arrange
    expected_response = account_balances_response
    allow_any_instance_of(PlaidService).to receive(:account_balance).and_return(expected_response)

    # Act
    get accounts_fetch_balance_path(account), xhr: true

    # Assert
    expect(response).to be_successful
    expect(account.reload.balance).to eq expected_response[0][:balances][:available]
  end
end
