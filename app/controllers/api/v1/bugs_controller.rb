# frozen_string_literal: true

module Api
  module V1
    class BugsController < ApiController # rubocop:disable Style/Documentation
      def index
        @bugs = Bug.by_project(params[:project_id])
        render json: @bugs.to_json(
          only: %i[id title description bug_type status project_id deadline]
        ),each_serializer: ProjectSerializer
      end

      def show
        @bug = Bug.find(params[:id])
        render json: @bug, serializer: ProjectSerializer
      end
    end
  end
end
