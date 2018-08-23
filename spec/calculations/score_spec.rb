require 'rails_helper'

shared_examples 'Returning empty string' do
  it 'Returns empty string' do
    expect(subject).to eq ''
  end
end

shared_examples 'Indicating invalid score' do
  it 'Returns question mark' do
    expect(subject).to eq '?'
  end
end

describe Score do
  subject do
    Score.result_for match
  end

  let!(:match) { FactoryBot.create(:match) }

  context 'With match not having any sets' do
    it_behaves_like 'Returning empty string'
  end

  context 'With match having a set with nil score' do
    let!(:set1) { FactoryBot.create(:game_set, match: match) }

    it_behaves_like 'Returning empty string'
  end

  context 'With match having a set with invalid score' do
    context 'Incomplete information' do
      let!(:set1) { FactoryBot.create(:game_set, match: match, score: [6]) }

      it_behaves_like 'Indicating invalid score'
    end

    context 'Nil containing' do
      let!(:set1) { FactoryBot.create(:game_set, match: match, score: [6, nil]) }

      it 'Returns zero instead of nil element' do
        expect(subject).to eq '6:0'
      end
    end
  end

  context 'With match having one set with valid score' do
    let!(:set1) { FactoryBot.create(:game_set, match: match, score: [6, 3]) }

    it 'Returns correct result' do
      expect(subject).to eq '6:3'
    end
  end

  context 'With match having three sets with valid score' do
    let!(:set1) { FactoryBot.create(:game_set, match: match, score: [6, 3]) }
    let!(:set2) { FactoryBot.create(:game_set, match: match, score: [4, 6]) }
    let!(:set3) { FactoryBot.create(:game_set, match: match, score: [4, 3]) }

    it 'Returns correct result' do
      expect(subject).to eq '6:3, 4:6, 4:3'
    end
  end

  context 'With match having three sets, one with invalid score' do
    let!(:set1) { FactoryBot.create(:game_set, match: match, score: [6, 3]) }
    let!(:set2) { FactoryBot.create(:game_set, match: match, score: [4]) }
    let!(:set3) { FactoryBot.create(:game_set, match: match, score: [4, 3]) }

    it_behaves_like 'Indicating invalid score'
  end
end
