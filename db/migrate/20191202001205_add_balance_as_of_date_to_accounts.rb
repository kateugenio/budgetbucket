class AddBalanceAsOfDateToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :balance_as_of_date, :date
  end
end
