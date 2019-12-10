class CreateBuckets < ActiveRecord::Migration[5.2]
  def change
    create_table :buckets do |t|
      t.string :name
      t.decimal :current_balance
      t.decimal :target_balance
      t.string :bucket_type
      t.string :description
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
