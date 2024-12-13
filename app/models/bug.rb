# frozen_string_literal: true

class Bug < ApplicationRecord
  VALID_EXTENSIONS = ['.png', '.gif'].freeze

  enum bug_type: { Feature: 0, Bug: 1 }
  enum status: { New: 0, Started: 1, Resolved: 2, Completed: 3 }

  belongs_to :project
  belongs_to :creater, class_name: 'User'

  belongs_to :assigned_to, class_name: 'User', foreign_key: :assigned_to, optional: true

  has_one_attached :screenshot

  validates_uniqueness_of :title, scope: :project_id

  validates :screenshot, content_type: %w[image/png image/gif], presence: true, allow_blank: true
  validates :title, :bug_type, :status, presence: true

  scope :by_project, ->(project_id) { where(project_id: project_id) }
end
