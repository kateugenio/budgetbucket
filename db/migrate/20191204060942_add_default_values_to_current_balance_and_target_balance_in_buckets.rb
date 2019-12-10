class AddDefaultValuesToCurrentBalanceAndTargetBalanceInBuckets < ActiveRecord::Migration[5.2]
  def change
    change_column_default :buckets, :current_balance, 0
    change_column_default :buckets, :target_balance, 0
  end
end
