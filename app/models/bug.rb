# frozen_string_literal: true

class Bug < ApplicationRecord
  VALID_EXTENSIONS = [".png", ".gif"].freeze

  enum bug_type: { Feature: 0, Bug: 1 }
  enum status: { New: 0, Started: 1, Resolved: 2, Completed: 3 }

  belongs_to :project
  belongs_to :creater, class_name: "User"

  belongs_to :assigned_to, class_name: "User", foreign_key: :assigned_to, optional: true

  has_one_attached :screenshot
  validates :screenshot, content_type: 'image/png'

  validates :title, :bug_type, :status, presence: true
  validates_uniqueness_of :title, scope: :project_id

  # validate :screenshot_type

  scope :by_project, ->(project_id) { where(project_id: project_id) }

  private



#   def screenshot_type
#     return unless screenshot.attached?

#     return if VALID_EXTENSIONS.include?(File.extname(screenshot.filename.to_s).downcase)

#     errors.add(:screenshot, "only supports .png or .gif")
#   end
 end
