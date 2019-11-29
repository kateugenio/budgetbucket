class Account < ApplicationRecord
  belongs_to :user

  validates :access_token, :account_id,
            :account_name, :account_type, presence: true

  def update_with_cached_metadata
    cached_metadata = Rails.cache.fetch("/users/#{user_id}/external_accounts")
    account = cached_metadata[:accounts].find { |account| account[:id] == account_id }
    assign_attributes(account_name: account[:name], mask: account[:mask],
                      account_type: account[:subtype], access_token: cached_metadata[:access_token])
  end
end
