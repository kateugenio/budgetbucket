module AccountsHelper
  def success_or_danger_based_on_amount(account)
    return 'badge-secondary' if account.budget_greater_than_or_equal_to_zero?

    'badge-danger'
  end

  def excess_budget_to_default_spending_amount(current_budget_amount, default_spending_bucket)
    current_default_spending_bucket_amt = default_spending_bucket.current_balance
    current_default_spending_bucket_amt + current_budget_amount
  end
end
