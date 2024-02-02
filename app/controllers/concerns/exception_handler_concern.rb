# frozen_string_literal: true

module ExceptionHandlerConcern
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_authenticity_token
    rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
    rescue_from ArgumentError, with: :handle_argument_error
    rescue_from NoMethodError, with: :handle_no_method_error
  end

  private

  def user_not_authorized
    flash[:alert] = "You don't have permission to perform this action."
    redirect_to root_path
  end

  def record_not_found
    flash[:alert] = 'Record not found.'
    redirect_to root_path
  end

  def handle_invalid_authenticity_token
    flash[:alert] = 'Invalid authenticity token.'
    redirect_to root_path
  end

  def handle_parameter_missing
    flash[:alert] = 'Required parameter is missing.'
    redirect_to root_path
  end

  def handle_argument_error
    flash[:alert] = 'An argument error occurred.'
    redirect_to root_path
  end

  def handle_no_method_error(exception)
    flash[:alert] = "Caught a NoMethodError: #{exception.message}"
    redirect_to root_path
  end
end
