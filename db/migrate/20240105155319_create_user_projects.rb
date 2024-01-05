# frozen_string_literal: true

class CreateUserProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :user_projects do |t|
      t.references :users, null: false, foreign_key: true
      t.references :projects, null: false, foreign_key: true

      t.timestamps
    end
  end
end
