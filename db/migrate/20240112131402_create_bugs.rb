# frozen_string_literal: true

class CreateBugs < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change # rubocop:disable Metrics/MethodLength
    create_table :bugs do |t|
      t.string :title, null: false
      t.string :description
      t.string :screenshot
      t.date :deadline
      t.integer :status, default: 0
      t.integer :bug_type, default: 0
      t.references :creater, null: false, foreign_key: { to_table: :users }
      t.references :project, null: false, foreign_key: true
      t.integer :assigned_to

      t.timestamps
    end

    add_index :bugs, :title
  end
end
