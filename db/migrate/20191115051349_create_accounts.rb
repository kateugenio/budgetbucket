class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :access_token
      t.string :item_id
      t.string :account_id
      t.string :account_name
      t.string :type
      t.string :mask

      t.timestamps
    end
  end
end
