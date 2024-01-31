# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'creates a user project after creation' do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, created_by: user.id)

    expect(UserProject.where(user_id: user.id, project_id: project.id)).to exist
  end

  it 'associates users through user_projects' do
    project = FactoryBot.create(:project)
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)

    project.users << user1
    project.users << user2

    expect(project.users).to include(user1, user2)
  end

  it 'destroys associated bugs when destroyed' do
    project = FactoryBot.create(:project)

    bug1 = FactoryBot.create(:bug, project: project)
    bug2 = FactoryBot.create(:bug, project: project)

    expect(project.bugs).to include(bug1, bug2)

    ActiveRecord::Base.transaction do
      expect { project.destroy }.to change { Bug.count }.by(-2)
    end

    expect { bug1.reload }.to raise_error(ActiveRecord::RecordNotFound)
    expect { bug2.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
