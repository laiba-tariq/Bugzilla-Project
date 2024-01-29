FactoryBot.define do
  factory :project do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    created_by { association(:user) }
    created_at { Time.current }
    updated_at { Time.current }
  end
end
