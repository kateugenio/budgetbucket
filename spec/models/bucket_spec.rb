require 'rails_helper'

RSpec.describe Bucket, type: :model do
  let(:bucket) { create(:bucket) }

  describe '#validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:bucket_type) }
    it {
      is_expected.to validate_inclusion_of(:bucket_type).in_array(Bucket::BUCKET_TYPES.map(&:last))
    }
    it { is_expected.to validate_numericality_of(:current_balance) }
    it { is_expected.to validate_numericality_of(:target_balance) }
  end

  describe '#custom validations' do
    it 'does not allow negative current balance' do
      # Act
      bucket.update(current_balance: -100)

      # Assert
      expect(bucket).not_to be_valid
    end

    it 'does not allow default spending bucket type to be updated' do
      # Arrange
      bucket.update(bucket_type: 'DEFAULT_SPENDING')

      # Act
      bucket.update(bucket_type: 'RECURRING_EXPENSE')

      # Assert
      expect(bucket).not_to be_valid
    end
  end

  describe '#callbacks' do
    it 'sets current_balance to zero if it is not present' do
      # Arrange
      account = create(:account)
      new_bucket = account.buckets.new(name: 'Loan', bucket_type: 'RECURRING_EXPENSE',
                                       target_balance: 200)

      # Assume
      expect(new_bucket.current_balance).to be_nil

      # Act
      new_bucket.save

      # Assert
      expect(new_bucket.current_balance).to eq 0
    end

    it 'does not allow default spending bucket to be destroyed' do
      # Arrange
      bucket.update(bucket_type: 'DEFAULT_SPENDING')

      # Act
      bucket.destroy

      # Assert
      expect(bucket.errors.messages[:bucket]).to include 'Cannot delete Default Spending Bucket'
    end
  end
end
