require 'rails_helper'

RSpec.describe UserProject, type: :model do
  it "validates uniqueness of user within a project" do
    user = create(:user)
    project = create(:project)

    valid_user_project = create(:user_project, user_id: user.id, project_id: project.id)
    expect(valid_user_project).to be_valid

    duplicate_user_project = build(:user_project, user_id: user.id, project_id: project.id)

    expect(duplicate_user_project).not_to be_valid

    expect(duplicate_user_project.errors[:user_id]).to include("has already been taken")

    expect(duplicate_user_project.save).to be_falsey
  end
end
