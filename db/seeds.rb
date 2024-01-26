# frozen_string_literal: true

users_data = [
  { email: 'saad123@gmail.com', password: 'saad1234', username: 'saad ali3', role: 0 },
  { email: 'aliza23@gmail.com', password: 'aliza23', username: 'Aliza Tariq', role: 1 },
  { email: 'saliha90@gmail.com', password: 'saliha23', username: 'Saliha Qaiser', role: 0 },
  { email: 'abdullah87@gmail.com', password: 'abdullah89', username: 'Abdullah Nasir', role: 'qa' }
]

users_data.each do |user|
  User.create!(user)
end

projects_data = [
  { name: 'project3', description: 'Project3 Description', created_by: User.find_by(username: 'Aliza Tariq').id },
  { name: 'project4', description: 'Project4 Description', created_by: User.find_by(username: 'Aliza Tariq').id },
  { name: 'project5', description: 'Project5 Description', created_by: User.find_by(username: 'Aliza Tariq').id },
  { name: 'project2', description: 'Project2 Description', created_by: User.find_by(username: 'saad ali3').id },
  { name: 'project1', description: 'Project1 Description', created_by: User.find_by(username: 'saad ali3').id },
  { name: 'project6', description: 'Project6 Description', created_by: User.find_by(username: 'Aliza Tariq').id },
  { name: 'project7', description: 'Project7 Description', created_by: User.find_by(username: 'Saliha Qaiser').id }
]

projects_data.each do |project|
  Project.find_or_create_by!(project)
end
