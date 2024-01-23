class CreateBugs < ActiveRecord::Migration[7.1]
  def change
    create_table :bugs do |t|
      t.string :title
      t.string :description
      t.string :screenshot
      t.datetime :deadline
      t.integer :bug_status, default: 0
      t.integer :bug_type, default: 0
      t.integer :assigned_to

      t.timestamps
    end
  end
end
