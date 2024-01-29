# spec/models/bug_spec.rb
require "rails_helper"

RSpec.describe Bug, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project) }

  describe "validations" do
    it "validates that :title is case-sensitively unique within the scope of :project_id" do
      existing_bug = create(:bug, project: project)

      new_bug = build(:bug, title: existing_bug.title.upcase, project: project)

      expect(new_bug).not_to be_valid
    end

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:bug_type) }
    it { should validate_presence_of(:status) }

    it "validates the content type of screenshot" do
      project = create(:project)
      user = create(:user)

      invalid_file_content = "invalid content"
      bug_with_invalid_screenshot = build(:bug, project: project, creater: user)
      bug_with_invalid_screenshot.screenshot.attach(io: StringIO.new(invalid_file_content), filename: "invalid_file.txt", content_type: "text/plain")

      expect(bug_with_invalid_screenshot).not_to be_valid
      expect(bug_with_invalid_screenshot.errors[:screenshot]).to include("has an invalid content type")

      bug_without_screenshot = build(:bug, project: project,creater: user,screenshot: nil)
      expect(bug_without_screenshot).to be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:project) }
    it { should belong_to(:creater).class_name("User").with_foreign_key("creater_id") }
    it { should belong_to(:assigned_to).class_name("User").with_foreign_key("assigned_to").optional(true) }
    it { should have_one_attached(:screenshot) }
  end

  describe "scopes" do
    describe ".by_project" do
      it "returns bugs for a specific project" do
        bug_in_project = create(:bug, project: project)
        bug_not_in_project = create(:bug)

        bugs = Bug.by_project(project.id)

        expect(bugs).to include(bug_in_project)
        expect(bugs).not_to include(bug_not_in_project)
      end
    end
  end
end
