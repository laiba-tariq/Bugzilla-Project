# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You don't have permission to perform this action."
    redirect_to root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username user_type])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:user_type])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username user_type])
  end
end
