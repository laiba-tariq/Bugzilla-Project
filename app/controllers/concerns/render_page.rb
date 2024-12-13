# frozen_string_literal: true

module RenderPage
  extend ActiveSupport::Concern

  def render_project
    render turbo_stream: [
      turbo_stream.replace('project_frame', partial: 'project', locals: { projects: @projects }),
      turbo_stream.remove('project')
    ]
  end
end
