FactoryBot.define do
  factory :match do
    association :court
    label { Faker::Lorem.word }

    trait :started do
      started_at { 2.hours.ago }
    end

    trait :finished do
      started_at { 2.hours.ago }
      finished_at { 30.minutes.ago }
    end
  end
end
