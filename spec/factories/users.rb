# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'saad1234' }
    sequence(:username) { |n| "#{Faker::Internet.user_name}_#{n}" }
    role { 0 }

    trait :role_0 do
      role { 0 }
    end

    trait :role_1 do
      role { 1 }
    end

    trait :role_2 do

      role { 2 }
    end
  end
end
