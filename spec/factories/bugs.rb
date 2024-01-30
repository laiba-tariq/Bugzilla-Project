# spec/factories/bugs.rb
FactoryBot.define do
  factory :bug do
    title { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    deadline { Faker::Date.forward(days: 30) }
    bug_type { Bug.bug_types.keys.sample }
    association :creater, factory: :user
    association :project, factory: :project
  end
end
