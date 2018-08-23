FactoryBot.define do
  factory :court do
    association :tournament
    label { Faker::Lorem.word }
  end
end
