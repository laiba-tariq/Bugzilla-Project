# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_projects
  has_many :projects, through: :user_projects

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :user_projects, dependent: :destroy
  has_many :projects, through: :user_projects
  validates :username, presence: true, uniqueness: true
  validates :usertype, presence: true
end
