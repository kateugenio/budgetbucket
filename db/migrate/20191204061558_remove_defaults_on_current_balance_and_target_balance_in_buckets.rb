class RemoveDefaultsOnCurrentBalanceAndTargetBalanceInBuckets < ActiveRecord::Migration[5.2]
  def change
    change_column_default :buckets, :current_balance, nil
    change_column_default :buckets, :target_balance, nil
  end
end
