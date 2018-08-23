require 'rails_helper'

describe TournamentMatchesQuery do
  subject do
    TournamentMatchesQuery.call(user: tournament1.user)
  end

  let!(:tournament1) { FactoryBot.create(:tournament) }
  let!(:court11) { FactoryBot.create(:court, tournament: tournament1) }
  let!(:match111) { FactoryBot.create(:match, court: court11) }
  let!(:court12) { FactoryBot.create(:court, tournament: tournament1) }
  let!(:match121) { FactoryBot.create(:match, court: court12) }
  let!(:match122) { FactoryBot.create(:match, court: court12) }

  let!(:tournament2) { FactoryBot.create(:tournament) }
  let!(:court21) { FactoryBot.create(:court, tournament: tournament2) }
  let!(:match211) { FactoryBot.create(:match, court: court21) }
  let!(:match212) { FactoryBot.create(:match, court: court21) }

  it "Returns matches belonging to given user's tournament" do
    matches = subject
    
    expect(matches.count).to eq 3
    expect(matches.pluck(:id)).to match_array [match111.id, match121.id, match122.id]
  end
end
