# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :description
      t.integer :created_by

      t.timestamps
    end

    add_index :projects, :name, unique: true
  end
end
