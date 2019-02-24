require 'rails_helper'

describe CourtDecorator do
  describe 'available_for?' do
    subject { CourtDecorator.new(court).available_for?(match, court_occupations_of(court.tournament)) }

    let!(:court) { FactoryBot.create(:court) }

    context 'With finished match and other existing match in progress on that court' do
      let!(:match) { FactoryBot.create(:match, :finished, court: court) }
      let!(:match_in_progress) { FactoryBot.create(:match, :in_progress, court: court) }

      it 'Returns true' do
        expect(subject).to be true
      end
    end

    context 'With match in progress and other existing matches on that court' do
      let!(:match) { FactoryBot.create(:match, :in_progress, court: court) }
      let!(:other_match) { FactoryBot.create(:match, court: court) }

      it 'Returns true' do
        expect(subject).to be true
      end
    end

    context 'With some planned matches on that court' do
      let!(:match) { FactoryBot.create(:match, court: court) }
      let!(:other_match) { FactoryBot.create(:match, court: court) }

      it 'Returns true' do
        expect(subject).to be true
      end
    end

    context 'With planned match and one match in progress on that court' do
      let!(:match) { FactoryBot.create(:match, court: court) }
      let!(:match_in_progress) { FactoryBot.create(:match, :in_progress, court: court) }

      it 'Returns false' do
        expect(subject).to be false
      end
    end

    context 'With planned match and one match in progress on another court' do
      let!(:match) { FactoryBot.create(:match, court: court) }
      let!(:another_court) { FactoryBot.create(:court, tournament: court.tournament) }
      let!(:match_in_progress) { FactoryBot.create(:match, court: another_court) }

      it 'Returns true' do
        expect(subject).to be true
      end
    end


    def court_occupations_of(tournament)
      tournament.courts.joins(:matches).merge(Match.in_progress).group('courts.id').count
    end
  end
end
