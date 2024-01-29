FactoryBot.define do
  factory :bug do
    title { Faker::Lorem.unique.word }
    description { Faker::Lorem.sentence }
    deadline { Faker::Date.forward(days: 30) }
    status { 0 }
    bug_type { 0 }
    creater_id { association(:user).id } # Use association(:user).id to get the user ID
    association :project, factory: :project, strategy: :create
    assigned_to { nil }
    created_at { Faker::Time.between(from: 2.years.ago, to: Time.current) }
    updated_at { Faker::Time.between(from: created_at, to: Time.current) }

    trait :with_screenshot do
      screenshot { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'example_screenshot.png')) }
    end

    transient do
      with_screenshot { false }
    end

    after(:build) do |bug, evaluator|
      bug.screenshot = evaluator.with_screenshot if evaluator.with_screenshot
    end
  end
end
