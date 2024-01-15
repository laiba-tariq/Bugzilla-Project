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
User.create({ email: 'saad12@gmail.com', password: 'saad1234', username: 'saad ali',
              user_type: 'manager' })
User.create({ email: 'aliza23@gmail.com', password: 'aliza23', username: 'Aliza Tariq',
              user_type: 'developer' })
User.create({ email: 'saliha90@gmail.com', password: 'saliha23', username: 'Saliha Qaiser',
              user_type: 'developer' })

User.create({ email: 'abdullah87@gmail.com', password: 'abdullah89', username: 'Abdullah Nasir',
              user_type: 'QA' })
