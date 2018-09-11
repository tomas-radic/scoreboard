FactoryBot.define do
  factory :match do
    association :court
    participant1 { Faker::Name.name }
    participant2 { Faker::Name.name }

    trait :started do
      started_at { 2.hours.ago }
    end

    trait :finished do
      started_at { 2.hours.ago }
      finished_at { 30.minutes.ago }
    end
  end
end
