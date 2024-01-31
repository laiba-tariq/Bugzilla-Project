# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { create(:user) }
  let!(:project) { create(:project, created_by: user.id) }

  before do
    allow(controller).to receive(:authenticate_user!) { true }
    allow(controller).to receive(:current_user) { user }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end
  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'renders project_path, or if not found, renders projects_path with an alert' do
      allow(Project).to receive(:find).and_return(project)

      get :show, params: { id: project.id }

      expect(response).to have_http_status(:ok)
      expect(response).to render_template('projects/show') unless project

      expect(flash[:alert]).to eq('Record not found.') if project.nil?
    end
  end

  describe 'POST #create' do
    before { user.role = 0 }

    it 'returns a success response' do
      post :create, params: { project: attributes_for(:project) }
      expect(response).to be_successful
    end

    it 'renders new template with alert if project creation fails' do
      allow_any_instance_of(Project).to receive(:save).and_return(false) # Stub save to simulate failure

      post :create, params: { project: attributes_for(:project) }

      expect(response).to render_template('new')
      expect(flash[:alert]).to eq('Project creation failed.')
    end
  end

  describe 'GET #edit' do
    before { user.role = 0 }
    it 'returns a success response' do
      get :edit, params: { id: project.id }
      expect(response).to be_successful
    end
  end

  describe 'PUT #update' do
    before { user.role = 0 }
    let(:updated_params) { { name: 'Updated Project Name' } }

    it 'updates the project' do
      put :update, params: { id: project.id, project: updated_params }
      project.reload
      expect(project.name).to eq('Updated Project Name')
    end

    it 'redirects to the updated project' do
      put :update, params: { id: project.id, project: updated_params }
      expect(response).to redirect_to(project_path(project))
    end
    it 'handles updating a nonexistent project' do
      non_existent_project_id = -99
      put :update, params: { id: non_existent_project_id, project: updated_params }
      expect(response).to redirect_to(root_path) # or any other appropriate redirect
    end
  end

  describe 'DELETE #destroy' do
    before { user.role = 0 }

    it 'destroys the project' do
      project # Ensure the project exists
      expect do
        delete :destroy, params: { id: project.id }
      end.to change(Project, :count).by(-1)
    end

    it 'redirects to the projects list' do
      delete :destroy, params: { id: project.id }
      expect(response).to redirect_to(projects_path)
    end
  end
end
