# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Users data
# Users data
users_data = [
  { email: 'saad12@gmail.com', encrypted_password: 'saad1234', username: 'saad ali', role: 'manager' },
  { email: 'aliza23@gmail.com', encrypted_password: 'aliza23', username: 'Aliza Tariq', role: 'developer' },
  { email: 'saliha90@gmail.com', encrypted_password: 'saliha23', username: 'Saliha Qaiser', role: 'developer' },
  { email: 'abdullah87@gmail.com', encrypted_password: 'abdullah89', username: 'Abdullah Nasir', role: 'QA' }
]

users_data.each do |user|
  User.find_or_create_by!(user)
end

# Projects data
projects_data = [
  { name: 'project3', description: 'Project3 Description', created_by: User.find_by(username: 'Aliza Tariq').id },
  { name: 'project4', description: 'Project4 Description', created_by: User.find_by(username: 'Aliza Tariq').id },
  { name: 'project5', description: 'Project5 Description', created_by: User.find_by(username: 'Aliza Tariq').id },
  { name: 'project2', description: 'Project2 Description', created_by: User.find_by(username: 'saad ali').id },
  { name: 'project1', description: 'Project1 Description', created_by: User.find_by(username: 'saad ali').id },
  { name: 'project6', description: 'Project6 Description', created_by: User.find_by(username: 'Aliza Tariq').id },
  { name: 'project7', description: 'Project7 Description', created_by: User.find_by(username: 'Saliha Qaiser').id }
]

projects_data.each do |project|
  Project.find_or_create_by!(project)
end
