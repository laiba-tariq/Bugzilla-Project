class Bug < ApplicationRecord
  belongs_to :project
  belongs_to :creater, class_name: 'User'
  enum bug_status: { New: 0, Started: 1, Resolved: 2, Completed: 3 }

  enum bug_type: { Feature: 0, Bug: 1 }
  has_one_attached :screenshot
  validates :title, :bug_type, :bug_status, presence: true
  validates_uniqueness_of :title, scope: :project_id
end
