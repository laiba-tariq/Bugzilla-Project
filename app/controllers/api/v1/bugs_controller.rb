# frozen_string_literal: true
module Api
  module V1
    class BugsController < ApiController # rubocop:disable Style/Documentation
      def index
        @bugs = Bug.by_project(params[:project_id])
        render json: @bugs.to_json(
          only: [:id, :title, :description, :bug_type, :status, :project_id, :deadline],
        )
      end

      def show
        @bug = Bug.find(params[:id]) if Project.find(params[:id])
        render json: @bug
      end
    end
  end
end
