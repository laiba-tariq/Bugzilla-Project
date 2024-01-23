# frozen_string_literal: true

class User < ApplicationRecord # rubocop:disable Style/Documentation
  has_many :user_projects
  has_many :projects, through: :user_projects
  has_many :bugs
  enum role: { manager: 0, qa: 1, developer: 2 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  validates :username, presence: true, uniqueness: true
  validates :role, presence: true
end
