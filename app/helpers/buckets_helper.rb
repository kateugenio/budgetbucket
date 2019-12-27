module BucketsHelper
  def remaining_buckets_for_balance_transfer(account, bucket_to_be_destroyed)
    buckets = account.buckets.reject { |bucket| bucket == bucket_to_be_destroyed }
    buckets.map do |bucket|
      ["#{bucket.name} - #{number_to_currency(bucket.current_balance)}", bucket.id]
    end
  end
end
