FactoryBot.define do
  factory :user_project do
    association :user, factory: :user
    association :project, factory: :project
  end
end
