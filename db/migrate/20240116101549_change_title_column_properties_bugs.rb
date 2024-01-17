class ChangeTitleColumnPropertiesBugs < ActiveRecord::Migration[7.1]
  def up
    change_column :bugs, :title, :string, null: false
    add_index :bugs, :title
  end

  def down
    change_column :bugs, :title, :string, null: true
    remove_index :bugs, :title
  end
end
