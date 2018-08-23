FactoryBot.define do
  factory :match do
    association :court
    label { Faker::Lorem.word }
  end
end
