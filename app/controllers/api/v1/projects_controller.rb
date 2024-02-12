# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApiController
      def index
        @projects = Project.all
        render json: @projects
      end

      def show
        @project = Project.find(params[:id]) if Project.find(params[:id])
        render json: @project
      end
    end
  end
end
