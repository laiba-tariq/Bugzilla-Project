# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # include Pagy::Backend
  # include Pundit::Authorization
  # include ExceptionHandlerConcern

  # before_action :configure_permitted_parameters, if: :devise_controller?

  # protected

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up, keys: %i[username role])
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:role])
  #   devise_parameter_sanitizer.permit(:account_update, keys: %i[username role])
  # end
end
