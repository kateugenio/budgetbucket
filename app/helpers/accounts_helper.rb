module AccountsHelper
  def success_or_danger_based_on_amount(account)
    budget = account.to_budget_with
    budget >= 0 ? 'badge-secondary' : 'badge-danger'
  end
end
