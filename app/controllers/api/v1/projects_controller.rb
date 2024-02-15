# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ApiController
      skip_before_action :authenticate_user!, only: %i[index show]

      def index
        @projects = Project.all
        render json: @projects, each_serializer: ProjectSerializer
      end

      def show
        @project = Project.find(params[:id])
        render json: @project, serializer: ProjectSerializer
      end
    end
  end
end
