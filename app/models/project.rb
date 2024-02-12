  # frozen_string_literal: true

  class Project < ApplicationRecord
    has_many :user_projects, dependent: :destroy
    has_many :users, through: :user_projects
    has_many :bugs, dependent: :destroy

    validates :name, presence: true

    after_create :create_user_project

    private

    def create_user_project
      UserProject.create(user_id: created_by, project_id: id)
    end
  end
