require 'rails_helper'

shared_examples 'Updating match score' do
  it 'Sets score to 6:4, 2:0' do
    subject
    match.reload
    game_sets = match.reload.game_sets
    expect(game_sets.count).to eq 3
    expect(game_sets[0].score).to eq [6, 4]
    expect(game_sets[1].score).to eq [2, 0]
    expect(game_sets[2].score).to eq []
    expect(match.finished_at).to be_nil
  end
end

shared_examples 'Indicating invalid set score' do
  it 'Raises error' do
    expect{subject}.to raise_error 'Invalid set score'
  end
end

describe UpdateMatchState do
  subject do
    UpdateMatchState.call(match, score, finished).result
  end

  let!(:match) { FactoryBot.create(:match, started_at: start_time) }
  let!(:set1) { FactoryBot.create(:game_set, match: match) }
  let!(:set2) { FactoryBot.create(:game_set, match: match) }
  let!(:set3) { FactoryBot.create(:game_set, match: match) }
  let(:start_time) { 20.minutes.ago }
  let(:finished) { false }

  context 'With valid score attribute' do
    let(:score) do
      { '0' => ['6', '4'], '1' => ['2', '0'] }
    end

    it_behaves_like 'Updating match score'

    it 'Does not change start time' do
      subject
      expect(match.reload.started_at).to eq start_time
    end

    it 'Calculates and sets estimated start time if its not present' do
      match.started_at = nil
      subject

      expect(match.started_at).to be <= 1.hour.ago
    end

    it 'Returns true' do
      expect(subject).to be true
    end
  end

  context 'With valid score attribute, containing nil element' do
    let(:score) do
      { '0' => ['6', '4'], '1' => ['2', nil] }
    end

    it_behaves_like 'Updating match score'
  end

  context 'With valid score attribute, containing blank element' do
    let(:score) do
      { '0' => ['6', '4'], '1' => ['2', ''] }
    end

    it_behaves_like 'Updating match score'
  end

  context 'With invalid score attribute' do
    context 'Too few elements' do
      let(:score) do
        { '0' => ['6'] }
      end

      it_behaves_like 'Indicating invalid set score'
    end

    context 'Too many elements' do
      let(:score) do
        { '0' => ['6', '4'], '1' => ['2', '0', nil] }
      end

      it_behaves_like 'Indicating invalid set score'
    end
  end

  context 'Finishing unfinished match' do
    let(:finished) { true }
    let(:score) do
      { '0' => ['6', '4'], '1' => ['2', '0'] }
    end

    it 'Marks match as finished' do
      subject
      expect(match.reload.finished_at).not_to be_nil
    end

    it 'Returns false' do
      expect(subject).to be false
    end
  end

  context 'Finishing match already finished before' do
    let!(:match) { FactoryBot.create(:match, finished_at: finish_time) }
    let(:finish_time) { 5.hours.ago }
    let(:finished) { true }
    let(:score) do
      { '0' => ['6', '4'], '1' => ['6', '4'] }
    end

    it 'Does not change finish time' do
      subject
      expect(match.reload.finished_at).to eq finish_time
    end
  end

  context 'Unfinishing finished match' do
    let!(:match) { FactoryBot.create(:match, finished_at: 5.hours.ago) }
    let(:finished) { false }
    let(:score) do
      { '0' => ['6', '4'], '1' => ['6', '4'] }
    end

    it 'Marks match as not finished yet' do
      subject
      expect(match.reload.finished_at).to be_nil
    end

    it 'Returns true' do
      expect(subject).to be true
    end
  end

  context 'Finishing match with invalid score' do
    let(:finished) { true }
    let(:score) do
      { '0' => ['6', '4'], '1' => ['2', '0', nil] }
    end

    it 'Does not mark match as finished' do
      expect{subject}.to raise_error 'Invalid set score'
      expect(match.reload.finished_at).to be_nil
    end
  end

  context 'Sending blank values to delete set score' do
    let(:score) do
      { '0' => ['6', '4'], '1' => ['2', '0'], '2' => ['', nil] }
    end

    it_behaves_like 'Updating match score'
  end

  context 'When there is another match in progress on that court' do
    let!(:another_match) { FactoryBot.create(:match, :started) }
    let!(:match) { FactoryBot.create(:match, court: another_match.court) }
    let(:score) do
      { '0' => ['6', '4'], '1' => ['2', '0'] }
    end

    it 'Raises record invalid' do
      expect{subject}.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
