class Expense < ApplicationRecord
  #==============================*****ASSOCIATIONS*****==============================
  belongs_to :group, optional: true
  belongs_to :paid_by, class_name: "User"
  has_many :expense_splits, dependent: :destroy

  #==============================*****MODEL METHODS*****==============================
  def self.create_with_splits(user, expense_params)
    expense = user.expenses.new(
      description: expense_params[:description],
      amount: expense_params[:amount],
      tax: expense_params[:tax].presence || 0,
      tip: expense_params[:tip].presence || 0,
      split_type: expense_params[:split_type],
      group_id: expense_params[:group_id].presence
    )
    ActiveRecord::Base.transaction do
      expense.save!
      expense_params[:participants].each_value do |participant_hash|
        participant_hash.each { |user_id, amt| expense.expense_splits.create!(user_id: user_id.to_i, share: amt.to_f) }
      end
    end
    expense
  end
end
