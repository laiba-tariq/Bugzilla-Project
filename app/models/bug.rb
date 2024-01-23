# frozen_string_literal: true

class Bug < ApplicationRecord
  belongs_to :project
  belongs_to :creater, class_name: 'User'
  enum status: { New: 0, Started: 1, Resolved: 2, Completed: 3 }

  enum bug_type: { Feature: 0, Bug: 1 }
  has_one_attached :screenshot
  validates :title, :bug_type, :status, presence: true
  validates_uniqueness_of :title, scope: :project_id
  scope :get_project, ->(project_id) { where(project_id: project_id) }
  validate :screenshot_type

  private

  def screenshot_type
    return unless screenshot.attached?

    valid_extensions = ['.png', '.gif']
    return if valid_extensions.include?(File.extname(screenshot.filename.to_s).downcase)

    errors.add(:screenshot, 'only supports .png or .gif')
  end
end
