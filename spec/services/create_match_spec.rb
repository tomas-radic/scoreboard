require 'rails_helper'

describe CreateMatch do
  subject do
    CreateMatch.call(tournament, attributes).result
  end

  let!(:tournament) { FactoryBot.create(:tournament) }
  let!(:court) { FactoryBot.create(:court, tournament: tournament) }

  context 'With correct attributes' do
    let(:attributes) do
      ActionController::Parameters.new(
        match: {
          participant1: "Laure Howell",
          participant2: "Shani Littel",
          court_id: court.id,
          "not_before(1i)" => "1",
          "not_before(2i)" => "1",
          "not_before(3i)" => "1",
          "not_before(4i)" => "14",
          "not_before(5i)" => "30"
        },
        started: "1",
        max_sets_to_play: "5"
      )
    end

    it 'Creates the match with correct attributes and returns created match' do
      expect(subject).to be_a Match
      expect(tournament.matches.count).to eq 1
      match = tournament.matches.first
      expect(match).to have_attributes(
        participant1: 'Laure Howell',
        participant2: 'Shani Littel',
        court_id: court.id
      )
      expect(match.not_before.strftime('%k:%M')).to eq '14:30'
      expect(match.started_at).not_to be_nil
      expect(match.finished_at).to be_nil
      expect(match.game_sets.count).to eq 5
    end
  end

  context 'Setting not_before using hour information only' do
    let(:attributes) do
      ActionController::Parameters.new(
        match: {
          participant1: "Laure Howell",
          participant2: "Shani Littel",
          court_id: court.id,
          "not_before(1i)" => "1",
          "not_before(2i)" => "1",
          "not_before(3i)" => "1",
          "not_before(4i)" => "14",
          "not_before(5i)" => ""
        }
      )
    end

    it 'Sets correct not_before attribute' do
      subject
      expect(tournament.matches.first.not_before.strftime('%k:%M')).to eq '14:00'
    end
  end

  context 'When not_before attribute is not specified' do
    let(:attributes) do
      ActionController::Parameters.new(
        match: {
          participant1: "Laure Howell",
          participant2: "Shani Littel",
          court_id: court.id,
          "not_before(1i)" => "1",
          "not_before(2i)" => "1",
          "not_before(3i)" => "1",
          "not_before(4i)" => "",
          "not_before(5i)" => ""
        }
      )
    end

    it 'Sets not_before attribute to nil' do
      subject
      expect(tournament.matches.first.not_before).to be_nil
    end
  end

  context 'With some missing attributes' do
    let(:attributes) do
      ActionController::Parameters.new(
        match: {
          participant1: "",
          participant2: "Shani Littel",
          court_id: court.id
        }
      )
    end

    it 'Does not save the match and returns unsaved match' do
      match = subject
      expect(match).to be_a Match
      expect(match.persisted?).to be false
      expect(tournament.matches.count).to eq 0
    end
  end

  context 'With court belonging to different tournament of someone else' do
    let!(:another_court) { FactoryBot.create(:court) }
    let(:attributes) do
      ActionController::Parameters.new(
        match: {
          participant1: "Laure Howell",
          participant2: "Shani Littel",
          court_id: another_court.id
        }
      )
    end

    it 'Raises error' do
      expect{subject}.to raise_error 'Court ID not known!'
    end
  end
end
