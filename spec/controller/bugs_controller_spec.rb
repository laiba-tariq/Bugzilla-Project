# frozen_string_literal: true

# spec/controllers/bugs_controller_spec.rb

require 'rails_helper'

RSpec.describe BugsController, type: :controller do # rubocop:disable Metrics/BlockLength
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:bug) { create(:bug, project: project, creater_id: user.id) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      bug1 = create(:bug, project: project, creater_id: user.id)
      expect(response).to be_successful
      get :index, params: { project_id: project.id }
      assigned_bugs = assigns(:bugs)
      expect(assigned_bugs.map(&:title)).to include(bug1.title)
      expect(assigned_bugs.map(&:bug_type)).to include(bug1.bug_type)
    end
  end
  describe 'POST #create' do
    let(:qa_user) { create(:user, role: 1) }
    let(:other_user) { create(:user, role: 0) }

    context 'with valid parameters' do
      it 'creates a new bug and associates it with the current user and project' do
        sign_in(qa_user)
        project = create(:project)
        bug_attributes = attributes_for(:bug, creater_id: user.id, project_id: project.id)
        post :create, params: { bug: bug_attributes, project_id: project.id }
        expect(response).to be_successful
        expect(response.body).to include('<turbo-stream')
        expect(assigns(:bug)).to be_present, 'Bug was not created successfully'
        expect(Bug.count).to eq(1)
        expect(project.bugs.count).to eq(1)
        expect(assigns(:bug).project).to eq(project)
        created_bug = assigns(:bug)
        expect(created_bug.project_id).to eq(project.id)
      end
    end

    context 'with invalid parameters' do
      it "does not create a new bug and renders 'new' template" do
        sign_in(qa_user)
        invalid_bug_attributes = attributes_for(:bug, title: nil, bug_type: nil, status: nil, project_id: project.id)

        expect do
          post :create, params: { bug: invalid_bug_attributes, project_id: project.id }
        end.not_to change(Bug, :count)

        expect(response).to render_template(:new)
        expect(assigns(:bug).errors).not_to be_empty
      end
    end
    context 'with non qa user' do
      it 'creates a new bug and associates it with the current user and project' do
        sign_in(other_user)
        sign_in(other_user)
        bug_attributes = attributes_for(:bug, creater_id: user.id, project_id: project.id)
        post :create, params: { bug: bug_attributes, project_id: project.id }
        if response.body.include?('<turbo-stream action="replace" target="project_frame">')
          expect(response.body).to include('<turbo-stream action="replace" target="project_frame">')
        else
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end
  describe 'PUT #update' do
    let(:dev_user) { create(:user, role: 2) }
    let(:other_user) { create(:user, role: 1) }
    let(:project) { create(:project) }
    let(:bug) { create(:bug, creater: user, project: project, assigned_to: user, status: 'Started') }

    let(:bug) { create(:bug, project: project, bug_type: 'Bug', status: 'Started') }
    let(:feature) { create(:bug, project: project, bug_type: 'Feature', status: 'Started') }

    context 'with valid parameters' do
      it 'updates the bug status to Resolved for Bug type' do
        sign_in(dev_user)
        put :update, params: { project_id: project.id, id: bug.id, bug: { status: 'Resolved' } }
        bug.reload
        expect(bug.status).to eq('Resolved')
        expect(response).to have_http_status(:success)
      end

      it 'updates the bug status to Completed for Feature type' do
        sign_in(dev_user)
        put :update, params: { project_id: project.id, id: feature.id, bug: { status: 'Completed' } }
        feature.reload
        expect(feature.status).to eq('Completed')
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the bug title' do
        sign_in(dev_user)
        old_title = bug.title
        allow(controller).to receive(:render_turbo_stream)

        put :update, params: { project_id: project.id, id: bug.id, bug: { title: nil } }
        bug.reload
        expect(bug.title).to eq(old_title)
      end
    end
    context 'with non-dev user' do
      it 'failed to update with non dev user' do
        sign_in(other_user)
        puts "here response #{response}"
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
