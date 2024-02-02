# frozen_string_literal: true

# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'saad1234' }
    sequence(:username) { |n| "#{Faker::Internet.user_name}_#{n}" }
    role { 0 }

    trait :role_manager do
      role { 0 }
    end

    trait :role_qa do
      role { 1 }
    end

    trait :role_developer do
      role { 2 }
    end
  end
end
