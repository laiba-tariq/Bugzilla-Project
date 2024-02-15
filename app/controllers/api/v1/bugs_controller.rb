# frozen_string_literal: true

module Api
  module V1
    class BugsController < ApiController # rubocop:disable Style/Documentation
      skip_before_action :authenticate_user!, only: %i[index]

      def index
        @bugs = Bug.by_project(params[:project_id])
        render json: @bugs.to_json(
          only: %i[id title description bug_type status project_id deadline]
        ), each_serializer: ProjectSerializer
      end
    end
  end
end
