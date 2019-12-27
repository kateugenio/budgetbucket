require 'rails_helper'

RSpec.describe BucketsHelper, type: :helper do
  let!(:account) { create(:account) }
  let!(:bucket) { create(:bucket, account: account) }

  describe '#remaining_buckets_for_balance_transfer' do
    it 'does not include bucket to be destroyed' do
      # Arrange
      bucket_to_be_destroyed = create(:bucket, account: account, name: 'Rent', current_balance: 100)
      create(:bucket, account: account, name: 'School Loan', current_balance: 500)

      # Assume
      expect(account.buckets.count).to be > 1

      # Assert
      unincluded_bucket = ["#{bucket_to_be_destroyed.name} - "\
                           "#{number_to_currency(bucket_to_be_destroyed.current_balance)}",
                           bucket.id]
      expect(helper.remaining_buckets_for_balance_transfer(account, bucket_to_be_destroyed))
        .not_to include unincluded_bucket
    end
  end
end
