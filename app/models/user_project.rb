# frozen_string_literal: true

class UserProject < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :user_id, uniqueness: { scope: :project_id }
  scope :by_user_id, ->(user_id) { where(user_id: user_id) }
end
