# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :authenticate_user!,exce

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username user_type])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:user_type])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username user_type])
  end
end
