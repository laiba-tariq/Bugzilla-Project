# frozen_string_literal: true

class AddCreatedByToProject < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :created_by, :bigint
  end
end
