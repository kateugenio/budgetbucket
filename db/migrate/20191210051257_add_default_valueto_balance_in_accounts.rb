class AddDefaultValuetoBalanceInAccounts < ActiveRecord::Migration[5.2]
  def change
    change_column_default :accounts, :balance, 0
  end
end
