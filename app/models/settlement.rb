class Settlement < ApplicationRecord
  #==============================*****VALIDATIONS*****==============================
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :settled_at, presence: true

  #==============================*****ASSOCIATIONS*****==============================
  belongs_to :from_user, class_name: "User"
  belongs_to :to_user, class_name: "User"
  belongs_to :group, optional: true
end
