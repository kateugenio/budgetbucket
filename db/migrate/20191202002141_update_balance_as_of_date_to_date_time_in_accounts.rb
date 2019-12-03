class UpdateBalanceAsOfDateToDateTimeInAccounts < ActiveRecord::Migration[5.2]
  def change
    change_column :accounts, :balance_as_of_date, :datetime
  end
end
