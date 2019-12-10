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
  validates :bucket_type, inclusion: { in: BUCKET_TYPES.map(&:last) }
  validates :current_balance, :target_balance, numericality: true, allow_blank: true

  validate :non_negative_balance

  before_save :set_current_balance_to_zero

  def set_current_balance_to_zero
    return if current_balance.present?

    assign_attributes(current_balance: 0)
  end

  def non_negative_balance
    return if current_balance.nil? || current_balance >= 0

    errors.add(:current_balance, "Current balance cannot be negative")
  end
end
