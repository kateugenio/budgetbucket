FactoryBot.define do
  factory :bucket do
    name { 'Rent' }
    current_balance { 500.00 }
    target_balance { 1000.00 }
    bucket_type { 'RECURRING_EXPENSE' }
    description { 'Due on the the 1st' }
    account { create(:account) }
  end
end
