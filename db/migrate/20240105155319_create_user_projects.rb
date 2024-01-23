# frozen_string_literal: true

class CreateUserProjects < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    create_table :user_projects do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.timestamps
    end

    add_index :user_projects, %i[user_id project_id], unique: true
  end
end
