require 'rails_helper'

RSpec.describe 'Buckets', type: :request do
  let(:user) { create(:user) }

  before {
    sign_in user
  }

  let(:account) { create(:account) }

  it 'renders new' do
    # Act
    get new_account_bucket_path(account), xhr: true

    # Assert
    expect(response).to be_successful
    expect(response).to render_template('new')
  end

  describe '#create' do
    it 'is successful' do
      # Arrange
      params = {
        bucket: {
          name: 'Mortgage',
          target_balance: '100',
          bucket_type: 'RECURRING_EXPENSE'
        }
      }
      buckets_before = account.buckets.count

      # Act
      post account_buckets_path(account, params: params)

      # Assert
      expect(response).to redirect_to(account_path(account))
      expect(account.buckets.count).to eq buckets_before + 1
    end

    it 'is unsuccessful' do
      # Arrange
      params = {
        bucket: {
          name: '',
          target_balance: '100',
          bucket_type: 'RECURRING_EXPENSE'
        }
      }
      buckets_before = account.buckets.count

      # Act
      post account_buckets_path(account, params: params), xhr: true

      # Assert
      expect(response).to render_template('new')
      expect(account.buckets.count).to eq buckets_before
      expect(flash[:error]).to include 'Bucket name cannot be blank'
    end
  end
end
