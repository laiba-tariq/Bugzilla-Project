# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Pundit::NotAuthorizedError, with: :render_not_authorized
  before_action :authenticate_user!

  private

  def render_404(exception) # rubocop:disable Naming/VariableNumber
    render_error_page(404, "Page not found: #{exception.message}")
  end

  def render_not_authorized(exception)
    render_error_page(403, "You are not authorized to perform this action: #{exception.message}")
  end

  def render_error_page(status, _message)
    render file: Rails.root.join('public', "#{status}.html"), status: status, layout: false
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username user_type])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:user_type])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username user_type])
  end
end
