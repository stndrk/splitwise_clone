# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def expense_records(user)
    user.expenses.order(created_at: :desc)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name mobile_number]) # Sign up
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name mobile_number]) # Account update (optional)
  end
end
