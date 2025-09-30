class GroupMembership < ApplicationRecord
  #==============================*****ASSOCIATIONS*****==============================
  belongs_to :group
  belongs_to :user
end
