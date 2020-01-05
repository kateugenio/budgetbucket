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

  describe '#update' do
    it 'updates' do
      # Act
      patch account_bucket_path(account, bucket,
                                params: { bucket: { description: 'A new description' } })

      # Assert
      expect(response).to redirect_to(account_path(account))
      expect(bucket.reload.description).to eq 'A new description'
    end

    it 'renders flash error if unsuccessful' do
      # Act
      patch account_bucket_path(account, bucket, params: { bucket: { bucket_type: '' } }), xhr: true

      # Assert
      expect(response).to render_template('edit')
      expect(flash[:error]).to include 'Must select a valid bucket type'
    end
  end

  describe '#update_balance' do
    it 'updates default spending bucket with excess budget' do
      # Arrange
      default_spending_current_balance = 200
      default_spending_bucket = create(:bucket, account: account,
                                       current_balance: default_spending_current_balance,
                                       bucket_type: 'DEFAULT_SPENDING')

      account_budget = account.to_budget_with
      total_amount = account_budget + default_spending_current_balance
      params = { bucket: { current_balance: total_amount }, excess_budget_update: true }

      # Act
      patch account_bucket_balance_path(account, default_spending_bucket, params: params), xhr: true

      # Assert
      expect(response).to be_successful
      expect(default_spending_bucket.reload.current_balance).to eq total_amount
    end
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

    it 'renders flash error if destroying a default spending bucket' do
      # Arrange
      bucket.update(bucket_type: 'DEFAULT_SPENDING')

      # Act
      delete account_bucket_path(account, bucket)

      # Assert
      expect(response).to redirect_to(account_path(account))
      expect(flash[:error]).to include 'Cannot delete Default Spending Bucket'
    end
  end
end
