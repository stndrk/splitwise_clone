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
    group = new(name: params[:name], description: params[:description], created_by: creator, admin: creator)

    Group.transaction do
      group.save!
      member_ids = Array(params.dig(:group, :member_ids)).reject(&:blank?).map(&:to_i)
      member_ids << creator.id unless member_ids.include?(creator.id)
      member_ids.each { |uid| group.group_memberships.create!(user_id: uid, active: true) }
    end

    group
  rescue ActiveRecord::RecordInvalid
    nil
  end
end
