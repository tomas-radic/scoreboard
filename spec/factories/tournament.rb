FactoryBot.define do
  factory :tournament do
    association :user
    label { Faker::Lorem.word }
  end
end
