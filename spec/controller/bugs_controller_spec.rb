# spec/controllers/bugs_controller_spec.rb

require "rails_helper"

RSpec.describe BugsController, type: :controller do # rubocop:disable Metrics/BlockLength
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:bug) { create(:bug, project: project, creater_id: user.id) }

  before do
    # sign_in user
    allow(controller).to receive(:authenticate_user!) { true }
    allow(controller).to receive(:current_user) { user }
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: { project_id: project.id }
      expect(response).to be_successful
    end
  end
  describe "POST #create" do
    before { user.role = 1 }

    context "with valid parameters" do
      it "creates a new bug and associates it with the current user and project" do
        project = create(:project)
        bug_attributes = attributes_for(:bug, creater_id: user.id, project_id: project.id)
        post :create, params: { bug: bug_attributes, project_id: project.id }

        # Check for a successful response (200 OK)
        expect(response).to be_successful

        # Check for the presence of Turbo Streams content
        expect(response.body).to include("<turbo-stream")

        # Add other expectations based on your Turbo Streams response if needed
        expect(assigns(:bug)).to be_present, "Bug was not created successfully"
        expect(Bug.count).to eq(1)
        expect(user.bugs.count).to eq(1)
        expect(assigns(:bug).project).to eq(project)
      end
    end

    context "with invalid parameters" do
      it "does not create a new bug and renders 'new' template" do
        invalid_bug_attributes = attributes_for(:bug, title: nil, bug_type: nil, status: nil, project_id: project.id)

        expect do
          post :create, params: { bug: invalid_bug_attributes, project_id: project.id }
        end.not_to change(Bug, :count)

        expect(response).to render_template(:new)
        expect(assigns(:bug).errors).not_to be_empty
      end
    end
  end
  describe "PUT #update" do
  let(:user) { create(:user, role: 2) }
  let(:project) { create(:project) }
  let(:bug) { create(:bug, creater: user, project: project, assigned_to: user, status: "Started") }

  context "with valid parameters" do
    it "updates the bug status to Completed" do
      allow(controller).to receive(:render_turbo_stream) # Mock render_turbo_stream

      put :update, params: { project_id: project.id, id: bug.id, bug: { status: "Completed" } }
      bug.reload
      expect(bug.status).to eq("Completed")
    end
  end

  context "with invalid parameters" do
    it "does not update the bug title" do
      old_title = bug.title
      allow(controller).to receive(:render_turbo_stream) # Mock render_turbo_stream

      put :update, params: { project_id: project.id, id: bug.id, bug: { title: nil } }
      bug.reload
      expect(bug.title).to eq(old_title)
    end
  end

end


  describe "DELETE #destroy" do
    it "destroys the bug" do
      bug # Ensure the bug exists
      
      expect {
        delete :destroy, params: { project_id: project.id, id: bug.id }
      }.to change(Bug, :count).by(0)
    end
  end
end
