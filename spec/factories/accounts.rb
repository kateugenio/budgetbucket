FactoryBot.define do
  factory :account do
    access_token { 1234567 }
    item_id { 112233 }
    account_id { 345435345 }
    account_name { 'Michael Scott Checking' }
    account_type { 'checking' }
    mask { 444 }
    user { User.first || create(:user) }
  end
end
