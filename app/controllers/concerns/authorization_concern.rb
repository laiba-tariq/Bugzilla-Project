# frozen_string_literal: true

module AuthorizationConcern
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  end

  private

  def user_not_authorized
    flash[:alert] = "You don't have permission to perform this action."
    redirect_to root_path
  end
end
