# frozen_string_literal: true

# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'FactoryBot' do
    it 'creates multiple users with different roles and unique usernames' do
      create_users_with_roles(%i[role_0 role_1 role_2], 3)

      expect(User.where(role: 0).count).to eq(3)
      expect(User.where(role: 1).count).to eq(3)
      expect(User.where(role: 2).count).to eq(3)
    end

    def create_users_with_roles(roles, count)
      roles.each do |role|
        FactoryBot.create_list(:user, count, role)
      end
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:username) }

    it 'validates case-sensitive uniqueness of username' do
      existing_user = FactoryBot.create(:user, username: 'existingUsername')
      new_user = FactoryBot.build(:user, username: existing_user.username.upcase)

      new_user.username = existing_user.username
      new_user.validate

      expect(new_user.errors[:username]).to include('has already been taken')
    end
    it { should validate_presence_of(:role) }
  end

  describe 'associations' do
    it { should have_many(:user_projects) }
    it { should have_many(:projects).through(:user_projects) }
    it { should have_many(:assigned_bugs).with_foreign_key(:assigned_to).class_name('Bug') }
    it { should have_many(:bugs).with_foreign_key(:creater_id) }
  end

  describe 'factory' do
    it 'is valid' do
      user = FactoryBot.create(:user)
      expect(user).to be_valid
      expect(user.role).to be_present
    end
  end
end
