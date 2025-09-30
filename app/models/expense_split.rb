class ExpenseSplit < ApplicationRecord
  #==============================*****ASSOCIATIONS*****==============================
  belongs_to :expense
  belongs_to :user

  validates :share, numericality: { greater_than_or_equal_to: 0 }
end
