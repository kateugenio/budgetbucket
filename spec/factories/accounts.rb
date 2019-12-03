FactoryBot.define do
  factory :account do
    access_token { 1_234_567 }
    item_id { 112_233 }
    account_id { 345_435_345 }
    account_name { 'Michael Scott Checking' }
    account_type { 'checking' }
    mask { 444 }
    institution_name { 'Chase Bank' }
    user { User.first || create(:user) }
  end
end
