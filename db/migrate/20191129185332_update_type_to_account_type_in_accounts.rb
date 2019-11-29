class UpdateTypeToAccountTypeInAccounts < ActiveRecord::Migration[5.2]
  def change
    rename_column :accounts, :type, :account_type
  end
end
