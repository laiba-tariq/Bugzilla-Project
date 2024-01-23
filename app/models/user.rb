# frozen_string_literal: true

class User < ApplicationRecord # rubocop:disable Style/Documentation
  enum role: { manager: 0, qa: 1, developer: 2 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_projects
  has_many :projects, through: :user_projects
  has_many :bugs

  validates :username, presence: true, uniqueness: true
  validates :role, presence: true
end
