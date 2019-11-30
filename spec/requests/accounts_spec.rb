require 'rails_helper'

RSpec.describe 'Accounts', type: :request do
  before {
    sign_in create(:user)
  }

  let(:external_accounts) { plaid_link_metadata }
  let(:account) { create(:account) }

  it 'sends plaid metadata and renders account information' do
    skip "Need to get this stub working"
    # Arrange
    stub_token_exchange_request

    # Assume
    plaid_service = double()
    allow(plaid_service).to receive(:exchange)
                        .and_return(access_token: external_accounts[:public_token],
                                    item_id: external_accounts[:item_id])

    # Act
    post metadata_path(public_token: external_accounts[:public_token],
                       metadata: external_accounts[:metadata]), xhr: true

    # Assert
    expect(response).to be_successful
  end

  it 'renders show' do
    # Act
    get account_path(account)

    # Assert
    expect(response).to be_successful
    expect(response).to render_template('show')
  end
end
