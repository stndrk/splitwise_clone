# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #==============================*****IN-BUILT VALIDATIONS*****==============================
  validates :password, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{7,}\z/,
                                 message: "must include uppercase, lowercase, number, and special character" }, if: lambda {
                                                                                                                      password.present?
                                                                                                                    }

  #==============================*****ASSOCIATIONS*****==============================
  has_many :group_memberships
  has_many :groups, through: :group_memberships
  has_many :expenses, class_name: "Expense", foreign_key: "paid_by_id"
  has_many :expense_splits
  has_many :payments, class_name: "Payment", foreign_key: "paid_by_id"
  has_many :created_groups, class_name: "Group", foreign_key: "created_by_id"
  has_many :admin_groups, class_name: "Group", foreign_key: "admin_id"
  has_many :settlements, class_name: "Settlement", foreign_key: "from_user_id"
  has_many :settlements_to, class_name: "Settlement", foreign_key: "to_user_id"

  #==============================*****MODAL LOGICS*****==============================

  def friends
    @friends ||= User.where.not(id: id)
  end

  # Total your friend owes you minus total you owe friend, considering settlements
  def net_balance_with(friend)
    amount_friend_pay_current_usr = expenses.joins(:expense_splits).where(expense_splits: {user_id: friend.id})
                                            .sum("COALESCE(expense_splits.share, 0)").to_f
    amount_current_usr_pay_friend = friend.expenses.joins(:expense_splits).where(expense_splits: {user_id: id})
                                          .sum("COALESCE(expense_splits.share, 0)").to_f
    settled_amount = Settlement.where(from_user_id: id, to_user_id: friend.id, status: "Success").sum(:amount) -
                     Settlement.where(from_user_id: friend.id, to_user_id: id, status: "Success").sum(:amount)
    amount_friend_pay_current_usr - amount_current_usr_pay_friend - settled_amount
  end

  # Total amount each friend needs to pay the current user
  def total_amount_friend_pay_current_usr
    @total_amount_friend_pay_current_usr ||= friends_balances.sum { |b| b[:amount_friend_pay_current_usr] }
  end

  # Total amount current user needs to pay each friend
  def total_amount_current_usr_pay_friend
    @total_amount_current_usr_pay_friend ||= friends_balances.sum { |b| b[:amount_current_usr_pay_friend] }
  end

  def friends_balances
    friends.map do |friend|
      balance = net_balance_with(friend)
      {friend: friend, amount_friend_pay_current_usr: [balance, 0].max, amount_current_usr_pay_friend: [balance, 0].min.abs}
    end
  end

  def relevant_groups
    @relevant_groups ||= Group.joins(:members).where("groups.created_by_id = ? OR users.id = ?", id, id).distinct
  end

  def groups_with_members
    relevant_groups.index_with do |group|
      group.members.map { |u| {id: u.id, name: u.name} }
    end
  end

  def expense_records
    expenses.order(created_at: :desc)
  end
end
