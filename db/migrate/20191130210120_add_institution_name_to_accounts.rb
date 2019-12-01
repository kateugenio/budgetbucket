class AddInstitutionNameToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :institution_name, :string
  end
end
