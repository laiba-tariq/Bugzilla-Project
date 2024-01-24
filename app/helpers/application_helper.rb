# frozen_string_literal: true

module ApplicationHelper
  def highlight_background?(current_user, project)
    current_user.qa? && current_user.projects.exists?(id: project.id)
  end
end
