require 'rails_helper'

RSpec.describe 'Buckets', type: :request do
  let(:user) { create(:user) }

  before {
    sign_in user
  }

  let(:account) { create(:account) }
  let(:bucket) { create(:bucket, account: account) }

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

  it 'renders edit' do
    # Act
    get edit_account_bucket_path(account, bucket), xhr: true

    # Assert
    expect(response).to be_successful
    expect(response).to render_template('edit')
  end

  it 'renders confirm destroy modal' do
    # Act
    get account_bucket_confirm_destroy_path(account, bucket), xhr: true

    # Assert
    expect(response).to be_successful
    expect(response).to render_template('confirm_destroy')
  end

  describe '#destroy' do
    it 'destroys' do
      # Act
      delete account_bucket_path(account, bucket)

      # Assert
      expect(response).to redirect_to(account_path(account))
    end

    it 'transfers remaining balance to selected transfer bucket' do
      # Arrange
      utilities_bucket = create(:bucket, account: account, current_balance: 100)
      utilities_bucket_balance_before = utilities_bucket.current_balance.to_i
      bucket_to_destroy_current_balance = bucket.current_balance.to_i

      # Assume
      expect(bucket.current_balance).to be > 0

      # Act
      delete account_bucket_path(account, bucket,
                                 params: { transfer_bucket_id: utilities_bucket.id })

      # Assert
      expect(response).to redirect_to(account_path(account))
      expect(utilities_bucket.reload.current_balance.to_i).to eq utilities_bucket_balance_before +
                                                                   bucket_to_destroy_current_balance
    end

    it 'resets account budget amount to account balance if the only bucket to destroy' do
      # Arrange
      current_bucket_balance = bucket.current_balance
      account_balance = account.balance

      # Assume
      expect(account.buckets.count).to eq 1
      expect(account.to_budget_with).to eq account.balance - current_bucket_balance

      # Act
      delete account_bucket_path(account, bucket)

      # Assert
      expect(response).to redirect_to(account_path(account))
      expect(account.reload.to_budget_with).to eq account_balance
    end
  end
end
