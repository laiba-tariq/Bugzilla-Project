# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user1 = User.create({ email: 'saad12@gmail.com', password: 'saad1234', username: 'saad ali',
                      usertype: 'manager' })
user2 = User.create({ email: 'aliza23@gmail.com', password: 'aliza23', username: 'Aliza Tariq',
                      usertype: 'developer' })
user3 = User.create({ email: 'saliha90@gmail.com', password: 'saliha23', username: 'Saliha Qaiser',
                      usertype: 'developer' })
User.create({ email: 'abdullah87@gmail.com', password: 'abdullah89', username: 'Abdullah Nasir',
              usertype: 'QA' })

project1 = Project.create({ project_name: 'project1', project_description: 'Project1 Description',
                            created_by: user1.id })
project2 = Project.create({ project_name: 'project2', project_description: 'Project2 Description',
                            created_by: user1.id })
project3 = Project.create({ project_name: 'project3', project_description: 'Project3 Description',
                            created_by: user2.id })
project4 = Project.create({ project_name: 'project4', project_description: 'Project4 Description',
                            created_by: user2.id })
project5 = Project.create({ project_name: 'project5', project_description: 'Project5 Description',
                            created_by: user2.id })
project6 = Project.create({ project_name: 'project6', project_description: 'Project6 Description',
                            created_by: user2.id })
project7 = Project.create({ project_name: 'project7', project_description: 'Project7 Description',
                            created_by: user3.id })
