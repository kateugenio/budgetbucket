class Account < ApplicationRecord
  belongs_to :user
  has_many :buckets

  validates :access_token, :account_id,
            :account_name, :account_type,
            :institution_name, presence: true

  after_commit :add_default_spending_bucket, on: :create


  #
  # Callback Methods
  #

  def add_default_spending_bucket
    buckets.create(name: 'Default Spending', bucket_type: 'DEFAULT_SPENDING',
                   description: 'Your spending bucket after all funds have been allocated to '\
                                'expense-type buckets')
  end

  #
  # End Callback Methods
  #

  #
  # Instance Methods
  #

  def update_with_cached_metadata
    cached_metadata = Rails.cache.fetch("/users/#{user_id}/external_accounts")
    account = cached_metadata[:accounts].find { |account| account[:id] == account_id }
    assign_attributes(account_name: account[:name], mask: account[:mask],
                      account_type: account[:subtype], access_token: cached_metadata[:access_token],
                      institution_name: cached_metadata[:institution_name])
  end

  def sum_of_all_bucket_balances
    buckets&.map(&:current_balance)&.sum
  end

  def to_budget_with
    balance - sum_of_all_bucket_balances
  end

  def budget_greater_than_or_equal_to_zero?
    to_budget_with >= 0
  end
end

#
# End Instance Methods
#
