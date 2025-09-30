class Payment < ApplicationRecord
  #==============================*****IN-BUILT VALIDATIONS*****==============================
  validates :name, presence: true,
                   uniqueness: { scope: :created_by_id, message: "You already created a group with this name" }

  has_many :users
end

class Payment < ApplicationRecord
  #==============================*****VALIDATIONS*****==============================
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :txn_id, uniqueness: true, allow_nil: true
  validates :payment_mode, presence: true

  #==============================*****ASSOCIATIONS*****==============================
  belongs_to :paid_by, class_name: "User" # Who made the payment
  belongs_to :paid_to, class_name: "User" # Who received the payment
end
