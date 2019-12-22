module AccountsHelper
  def success_or_danger_based_on_amount(account)
    return 'badge-secondary' if account.budget_greater_than_or_equal_to_zero?
    'badge-danger'
  end
end
