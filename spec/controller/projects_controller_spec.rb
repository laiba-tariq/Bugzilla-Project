# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { create(:user) }
  let!(:project) { create(:project, created_by: user.id) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      project1 = create(:project, created_by: user.id)
      project2 = create(:project, created_by: user.id)
      project3 = create(:project, created_by: user.id)
      get :index
      expect(response).to be_successful
      pagy_instance = assigns(:pagy)
      assigned_projects = assigns(:projects)
      expect(pagy_instance).to be_present
      expect(assigned_projects.map(&:name)).to include(project1.name, project2.name, project3.name)
      expect(assigned_projects.map(&:description)).to include(project1.description, project2.description,
                                                              project3.description)
    end
  end

  describe 'GET #new' do
    let(:manager_user) { create(:user, role: 0) }
    let(:other_user) { create(:user, role: 2) }
    it 'returns a success response' do
      sign_in(manager_user)
      get :new
      expect(response).to render_template(:new)
    end
    it 'non-manager user response' do
      sign_in(other_user)
      get :new
      expect(response).to have_http_status(:redirect)
      expect(flash[:alert]).to eq("You don't have permission to perform this action.")
    end
  end

  describe 'GET #show' do
    let(:manager_user) { create(:user, role: 0) }
    it 'renders project_path, or if not found, renders projects_path with an alert' do
      sign_in(manager_user)
      get :show, params: { id: project.id }

      expect(response).to have_http_status(:found)
      expect(response).to render_template('projects/show') unless project

      expect(flash[:alert]).to eq('Record not found.') if project.nil?
    end
    let(:other_user) { create(:user, role: 1) }
    it 'renders project_path,if non-manager user is signed in ' do
      sign_in(other_user)
      get :show, params: { id: project.id }
      expect(flash[:alert]).to eq('Record not found.') if project.nil? # deal exception
    end
  end

  describe 'POST #create' do
    let(:manager_user) { create(:user, role: 0) }

    it 'returns a success response for manager' do
      sign_in(manager_user)
      post :create, params: { project: attributes_for(:project) }
      expect(response).to be_successful
      raise('Unexpected response format. Turbo Stream expected.') unless response.content_type.include?('turbo-stream')

      expect(response.body).to include('replace', 'remove')
    end

    it 'renders new template with alert if project creation fails for non-manager' do
      other_user = create(:user)
      sign_in(other_user)

      post :create, params: { project: attributes_for(:project) }

      expect(response.body).to include('<turbo-stream action="replace" target="project_frame">')
      expect(response.body).to include('<turbo-stream action="remove" target="project">')
    end
    it 'renders new template with alert if project creation fails' do
      project_attributes = attributes_for(:project, name: nil)
      post :create, params: { project: project_attributes, created_by: user.id }
      expect(response).to render_template('new')
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
    let(:updated_params) { { name: 'Updated Project Name' } }
    let(:manager_user) { create(:user, role: 0) }
    it 'updates the project' do
      sign_in(manager_user)
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
      expect(response).to redirect_to(root_path)
    end
    it 'renders the edit template when update fails' do
      sign_in(manager_user)
      project_attributes = attribu
      tes_for(:project, name: nil)
      put :update, params: { id: project.id, project: project_attributes }
      expect(response).to render_template(:edit)
      expect(assigns(:project).errors[:name]).to include("can't be blank")
    end

    it 'renders project updation fails for non-manager' do
      other_user = create(:user)

      sign_in(other_user)
      project_attributes = attributes_for(:project, name: nil)
      put :update, params: { id: project.id, project: project_attributes }
      expect(response).to render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    let(:manager_user) { create(:user, role: 0) }

    context ' destroying the project' do
      it 'destroys the project' do
        sign_in(manager_user)
        project_to_destroy = create(:project)
        expect do
          delete :destroy, params: { id: project_to_destroy.id }
        end.to change(Project, :count).by(-1)
      end
      it 'redirects to the projects list' do
        sign_in(manager_user)
        project_to_destroy = create(:project)
        delete :destroy, params: { id: project_to_destroy.id }
        expect(response).to redirect_to(projects_path)
      end
    end
    context 'attempting to destroy a non-existent project' do
      non_existent_project_id = -99
      it 'does not change the Project count' do
        sign_in(manager_user)
        expect do
          delete :destroy, params: { id: non_existent_project_id }
        end.to_not change(Project, :count)
      end
      it 'renders an error or redirects appropriately' do
        sign_in(manager_user)
        delete :destroy, params: { id: non_existent_project_id }
        expect(response).to redirect_to(root_path)
      end
    end
    it 'renders new template with alert if project updation fails for non-manager' do
      non_existent_project_id = -99
      other_user = create(:user, role: 2)
      sign_in(other_user)
      delete :destroy, params: { id: non_existent_project_id }
      expect(response).to redirect_to(root_path)
    end
  end
end
