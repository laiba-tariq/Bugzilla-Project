# frozen_string_literal: true

module RenderProject
  extend ActiveSupport::Concern

  def update_page
    render turbo_stream: [
      turbo_stream.replace('project_frame', partial: 'project', locals: { projects: @projects }),
      turbo_stream.remove('project')
    ]
  end
end
