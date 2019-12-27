require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '#validations' do
    it { is_expected.to validate_presence_of(:account_id) }
    it { is_expected.to validate_presence_of(:access_token) }
    it { is_expected.to validate_presence_of(:account_name) }
    it { is_expected.to validate_presence_of(:account_type) }
    it { is_expected.to validate_presence_of(:institution_name) }
  end

  describe '#custom validations' do
    it 'creates default spending bucket after commit on create' do
      # Act
      account = create(:account)

      # Assert
      expect(account.buckets.last.default_spending_bucket?).to be true
    end
  end
end
