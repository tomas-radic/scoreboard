require 'rails_helper'

shared_examples 'Returning time information' do
  it 'Returns time information' do
    expect(subject).to eq ' 9:00'
  end
end

shared_examples 'Returning empty string' do
  it 'Returns empty string' do
    expect(subject).to eq ''
  end
end

describe NotBeforeInfo do
  subject do
    NotBeforeInfo.result_for match
  end

  context 'Scheduled match' do
    context 'Has not started yet' do
      let!(:match) { FactoryBot.create(:match, not_before: Time.zone.parse('9:00')) }

      it_behaves_like 'Returning time information'
    end

    context 'Started but not finished yet' do
      let!(:match) { FactoryBot.create(:match, :started, not_before: Time.zone.parse('9:00')) }

      it_behaves_like 'Returning empty string'
    end

    context 'Finished already' do
      let!(:match) { FactoryBot.create(:match, :finished, not_before: Time.zone.parse('9:00')) }

      it_behaves_like 'Returning empty string'
    end
  end

  context 'Unscheduled match' do
    context 'Has not started yet' do
      let!(:match) { FactoryBot.create(:match, not_before: nil) }

      it_behaves_like 'Returning empty string'
    end

    context 'Started but not finished yet' do
      let!(:match) { FactoryBot.create(:match, :started, not_before: nil) }

      it_behaves_like 'Returning empty string'
    end

    context 'Finished already' do
      let!(:match) { FactoryBot.create(:match, :finished, not_before: nil) }

      it_behaves_like 'Returning empty string'
    end
  end
end
