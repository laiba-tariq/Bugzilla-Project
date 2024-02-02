# frozen_string_literal: true

class HomeController < ApplicationController
  include ExceptionHandlerConcern

  def index
    redirect_to projects_path(current_user) if user_signed_in?
  end
end
