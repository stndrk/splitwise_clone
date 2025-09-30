class PersonController < ApplicationController
  before_action :authenticate_user!

  # Freate group and store their members
  def group_create
    group = Group.create_with_members(group_params.merge(member_ids: params[:group][:member_ids]), current_user)
    if group.persisted?
      redirect_to dashboard_path, notice: "Group created successfully."
    else
      redirect_to dashboard_path, alert: group.errors.full_messages.join(", ")
    end
  end

  # Freate expense and store their participants
  def expense_create
    Expense.create_with_splits(current_user, expense_params)
    redirect_to dashboard_path, notice: "Expense added successfully."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to dashboard_path, alert: e.record.errors.full_messages.join(", ")
  end

  # Fetch expense dynamically
  def expense_fetch
    user_id = params[:user_id]
    user = user_id.to_s == "me" ? current_user : User.find(user_id.to_i)
    @expenses = expense_records(user)
    render partial: "layouts/expenses_list", locals: { expenses: @expenses, user_id: user_id }
  end

  private

  def expense_params
    params.require(:expense).permit(:description, :amount, :tax, :tip, :split_type, :group_id,
                                    participants: {}).merge(split_type: params[:expense][:split_type] || params[:split_type])
  end

  def group_params
    params.permit(:name, :description)
  end
end
