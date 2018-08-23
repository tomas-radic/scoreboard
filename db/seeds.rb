
def recreate_tournament_for(user)
  user.tournament.destroy if user.tournament.present?
  puts "Recreating tournament for #{user.email}"

  Tournament.create!(
    user: user,
    label: "#{Faker::Address.city} Open",
    courts: [
      Court.new(
        label: '1',
        matches: [
          Match.new(
            label: "#{Faker::Name.name} - #{Faker::Name.name}",
            game_sets: [
              GameSet.new(score: [6, 4]),
              GameSet.new(score: [3, 6]),
              GameSet.new(score: [6, 3])
            ],
            started_at: 2.hours.ago,
            completed_at: 30.minutes.ago
          ),
          Match.new(
            label: "#{Faker::Name.name} - #{Faker::Name.name}",
            game_sets: [
              GameSet.new(score: [1, 4])
            ],
            started_at: 20.minutes.ago
          ),
          Match.new(
            label: "#{Faker::Name.name} - #{Faker::Name.name}"
          )
        ]
      ),
      Court.new(
        label: '2',
        matches: [
          Match.new(
            label: "#{Faker::Name.name} - #{Faker::Name.name}",
            game_sets: [
              GameSet.new(score: [4, 6]),
              GameSet.new(score: [5, 2])
            ],
            started_at: 80.minutes.ago
          ),
          Match.new(
            label: "#{Faker::Name.name} - #{Faker::Name.name}"
          )
        ]
      ),
      Court.new(
        label: '3',
        matches: [
          Match.new(
            label: "#{Faker::Name.name} - #{Faker::Name.name}",
            not_before: Time.zone.parse('15:00')
          )
        ]
      ),
      Court.new(
        label: '4'
      )
    ]
  )

  puts 'Done.'
end

user = User.where(
  email: 'tomas.radic@gmail.com'
).first_or_create!(
  password: 'Password',
  password_confirmation: 'Password'
)

if user.tournament.nil?
  recreate_tournament_for user
end
