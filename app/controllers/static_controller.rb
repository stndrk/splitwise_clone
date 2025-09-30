# frozen_string_literal: true

class StaticController < ApplicationController
  #rubocop:disable all
  def dashboard
    @friends = current_user.friends
    @friends_balances = current_user.friends_balances.index_by { |b| b[:friend].id } 
    @total_due_to_you   = current_user.total_amount_friend_pay_current_usr # This will be the amount you have paid for others but yet to receive 
    @total_you_owe = current_user.total_amount_current_usr_pay_friend # This will be the total amount you received from others, that you need to pay
    @total_balance    = @total_due_to_you - @total_you_owe # Amount due to the current user; you - the amount you owe
    @groups_with_members = current_user.relevant_groups.each_with_object({}) do |group, hash| # User's groups with members
      key = "#{group.name}-#{group.id}"
      hash[key] = group.members.map {|u| {id: u.id, name: u.name}}
    end
  end

  def person_page
    @friends = current_user.friends
    @groups  = current_user.groups
    @expenses = current_user.expense_records
    @groups_with_members = current_user.relevant_groups.each_with_object({}) do |group, hash|
      key = "#{group.name}-#{group.id}"
      hash[key] = group.members.map {|u| {id: u.id, name: u.name}}
    end
  end

  def settlement_create
    settlement = current_user.settlements.new(settlement_params.merge(status: "Success", settled_at: Time.current))
    if settlement.save
      redirect_to dashboard_path, notice: "Settlement created successfully!"
    else
      redirect_to dashboard_path, alert: settlement.errors.full_messages.join(", ")
    end
  end

  def settlement_amount
    friend = User.find(params[:friend_id].to_i)
    amount_owe = Expense.joins(:expense_splits).where(paid_by_id: friend.id).where(expense_splits: { user_id: current_user.id }).sum("COALESCE(expense_splits.share, 0)").to_f
    total_settled = Settlement.where(from_user_id: current_user.id, to_user_id: friend.id).sum("COALESCE(amount, 0)").to_f

    render json: {amount: (total_owe - total_settled).round(2)}
  end

  private

  def settlement_params
    params.permit(:to_user_id, :amount, :description, :group_id)
  end
end
