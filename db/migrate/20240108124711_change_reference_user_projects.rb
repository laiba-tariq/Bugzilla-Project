class ChangeReferenceUserProjects < ActiveRecord::Migration[7.1]
  def change
    remove_reference :user_projects, :users, foreign_key: true
    add_reference :user_projects, :user, foreign_key: true
    remove_reference :user_projects, :projects, foreign_key: true
    add_reference :user_projects, :project, foreign_key: true
  end
end
