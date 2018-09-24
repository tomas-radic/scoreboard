require 'rails_helper'

describe UpdateMatch do
  subject do
    UpdateMatch.call(match, attributes).result
  end

  let!(:match) { FactoryBot.create(:match) }
  let!(:game_set1) { FactoryBot.create(:game_set, match: match) }
  let!(:game_set2) { FactoryBot.create(:game_set, match: match) }
  let!(:game_set3) { FactoryBot.create(:game_set, match: match) }
  let!(:court) { FactoryBot.create(:court, tournament: match.tournament) }

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

    it 'Updates the match' do
      match = subject
      expect(match).to be_a Match
      expect(match.tournament.matches.count).to eq 1
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

    context 'When reducing maximum number of sets to play' do
      let(:attributes) do
        ActionController::Parameters.new(
          match: {
            participant1: "Laure Howell",
            participant2: "Shani Littel",
            court_id: court.id
          },
          max_sets_to_play: "1"
        )
      end

      it 'Does not reduce number of game_sets of the match' do
        match = subject
        expect(match).to be_a Match
        expect(match.reload.game_sets.count).to eq 3
      end
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
      expect(match.not_before.strftime('%k:%M')).to eq '14:00'
    end
  end

  context 'Clearing not_before' do
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

    it 'Clears not_before attribute' do
      subject
      expect(match.not_before).to be_nil
    end
  end

  context 'Clearing start/finish time' do
    let!(:match) { FactoryBot.create(:match, :finished) }
    let(:attributes) do
      ActionController::Parameters.new(
        match: {
          participant1: "Laure Howell",
          participant2: "Shani Littel",
          court_id: court.id
        }
      )
    end

    it 'Clears started_at and finished_at attributes' do
      subject
      expect(match.started_at).to be_nil
      expect(match.finished_at).to be_nil
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

    it 'Does not update the match' do
      match = subject
      expect(match).to be_a Match
      expect(match.reload.participant1.blank?).to be false
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
