class Bucket < ApplicationRecord
  belongs_to :account

  BUCKET_TYPES = [
    ['Recurring Expense', 'RECURRING_EXPENSE'],
    ['Variable Expense', 'VARIABLE_EXPENSE'],
    ['Spending', 'SPENDING'],
    ['Long Term Goal', 'LONG_TERM_GOAL'],
    ['Other', 'OTHER']
  ].freeze

  validates :name, :bucket_type, presence: true
  validates :bucket_type, inclusion: { in: BUCKET_TYPES.map(&:last).push('DEFAULT_SPENDING') }
  validates :current_balance, :target_balance, numericality: true, allow_blank: true

  validate :non_negative_balance
  validate :default_spending_bucket_type_cannot_be_edited, on: :update

  before_save :set_current_balance_to_zero
  before_destroy :default_spending_bucket_cannot_be_destroyed

  #
  # Callback Methods
  #

  def set_current_balance_to_zero
    return if current_balance.present?

    assign_attributes(current_balance: 0)
  end

  def default_spending_bucket_cannot_be_destroyed
    return unless default_spending_bucket?

    errors.add(:bucket, "Cannot delete Default Spending Bucket")
    throw :abort
  end

  #
  # End Callback Methods
  #

  #
  # Custom Validators
  #

  def non_negative_balance
    return if current_balance.nil? || current_balance >= 0

    errors.add(:current_balance, "Current balance cannot be negative")
  end

  def default_spending_bucket_type_cannot_be_edited
    return unless bucket_type_was == 'DEFAULT_SPENDING' && bucket_type_changed?

    errors.add(:bucket_type, "Cannot change bucket type for Default Spending bucket")
  end

  #
  # End Custom Validators
  #

  #
  # Instance Methods
  #

  def transfer_balance_before_destroy(bucket_to_be_destroyed)
    balance_to_transfer = bucket_to_be_destroyed.current_balance
    update(current_balance: self.current_balance += balance_to_transfer)
  end

  def default_spending_bucket?
    bucket_type == "DEFAULT_SPENDING"
  end

  #
  # End Instance Methods
end
