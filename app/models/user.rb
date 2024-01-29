# frozen_string_literal: true

class User < ApplicationRecord # rubocop:disable Style/Documentation
  enum role: { manager: 0, qa: 1, developer: 2 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_projects
  has_many :projects, through: :user_projects
  has_many :bugs, foreign_key: :creater_id
  has_many :assigned_bugs, foreign_key: :assigned_to, class_name: 'Bug'

  validates :username, presence: true, uniqueness: true
  validates :role, presence: true
end
