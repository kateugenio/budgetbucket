class Account < ApplicationRecord
  belongs_to :user

  validates :access_token, :item_id, :account_id,
            :account_name, :type, presence: true
end
