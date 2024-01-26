# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to projects_path(current_user)
    else
      render
    end
  end
end
