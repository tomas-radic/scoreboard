FactoryBot.define do
  factory :tournament do
    association :user
    label { Faker::Lorem.word }
    public_score_update { true }

    after :create do |tournament|
      3.times do |i|
        FactoryBot.create(:court, label: "#{i + 1}", tournament: tournament)
      end
    end
  end
end
