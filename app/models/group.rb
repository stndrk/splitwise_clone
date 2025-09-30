class Group < ApplicationRecord
  #==============================*****IN-BUILT VALIDATIONS*****==============================
  validates :name, presence: true,
                   uniqueness: { scope: :created_by_id, message: "You already created a group with this name" }

  #==============================*****ASSOCIATIONS*****==============================
  belongs_to :created_by, class_name: "User"
  belongs_to :admin, class_name: "User"
  has_many :expenses
  has_many :group_memberships
  has_many :members, through: :group_memberships, source: :user

  #==============================*****MODEL METHODS*****==============================
  def self.create_with_members(params, creator)
    group = new(params)
    group.created_by = creator
    group.admin = creator

    if group.save
      member_ids = params[:member_ids].reject(&:blank?)
      group.add_members(member_ids)
    end

    group
  end

  def add_members(user_ids)
    user_ids.each { |uid| group_memberships.create(user_id: uid, active: true) }
  end
end
