require 'rails_helper'

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
end

shared_examples 'Responding with success' do
  it 'Responds with success' do
    expect(subject).to have_http_status :ok
  end
end

shared_examples 'Redirecting to root' do
  it 'Redirects to root' do
    expect(subject).to redirect_to root_path
  end
end

shared_examples 'Redirecting to login' do
  it 'Redirects to login' do
    expect(subject).to redirect_to new_user_session_path(locale: nil)
  end
end

shared_examples 'Redirected' do
  it 'Redirects' do
    expect(subject).to have_http_status 302
  end
end

RSpec.describe MatchesController, type: :controller do
  let(:non_existing_id) { 'non-existing-id' }

  describe 'GET index' do
    subject { get :index, params: parameters }

    context 'Requesting matches of existing tournament' do
      let!(:tournament) { FactoryBot.create(:tournament) }
      let(:parameters) { { tournament_id: tournament.id } }

      it 'Renders index template' do
        expect(subject).to render_template :index
      end

      it_behaves_like 'Responding with success'
    end

    context 'Requesting matches of non existing tournament' do
      let(:parameters) { { tournament_id: non_existing_id } }

      it 'Redirects to tournament show page' do
        expect(subject).to redirect_to tournament_path(id: non_existing_id)
      end
    end
  end

  describe 'GET new' do
    subject { get :new, params: parameters }

    context 'With signed in user' do
      let!(:user) { FactoryBot.create(:user) }

      before :each do
        sign_in user
      end

      context 'With existing tournament of that user' do
        let!(:tournament) { FactoryBot.create(:tournament, user: user) }
        let(:parameters) { { tournament_id: tournament.id } }

        it 'Renders new template' do
          expect(subject).to render_template :new
        end

        it_behaves_like 'Responding with success'
      end

      context 'With existing tournament of other user' do
        let!(:tournament) { FactoryBot.create(:tournament) }
        let(:parameters) { { tournament_id: tournament.id } }

        it_behaves_like 'Redirecting to root'
      end
    end

    context 'Without signed in user' do
      let!(:tournament) { FactoryBot.create(:tournament) }
      let(:parameters) { { tournament_id: tournament.id } }

      it_behaves_like 'Redirecting to login'
    end
  end

  describe 'POST create' do
    subject { post :create, params: parameters }

    let(:parameters) do
      {
        "match" => {
          "participant1" => "Roger Federer",
          "participant2" => "Stefanos Tsitsipas",
          "court_id" => "court-id-here",
          "not_before(1i)" => "1",
          "not_before(2i)" => "1",
          "not_before(3i)" => "1",
          "not_before(4i)" => "13",
          "not_before(5i)" => "30"
        },
        "max_sets_to_play" => "3",
        "started" => "1",
        "tournament_id" => "tournament-id-here"
      }
    end

    before :each do
      parameters['tournament_id'] = tournament.id
      parameters['match']['court_id'] = tournament.courts.last.id
    end

    context 'With signed in user' do
      let!(:user) { FactoryBot.create(:user) }

      before :each do
        sign_in user
      end

      context 'With existing tournament of that user' do
        let!(:tournament) { FactoryBot.create(:tournament, user: user) }

        context 'And valid parameters' do
          it 'Creates new match for tournament' do
            subject

            expect(tournament.matches.count).to eq 1
            match = tournament.matches.last
            expect(match.participant1).to eq 'Roger Federer'
            expect(match.participant2).to eq 'Stefanos Tsitsipas'
            expect(match.court_id).to eq tournament.courts.last.id
            expect(match.not_before).not_to be_nil
            expect(match.started_at).not_to be_nil
            expect(match.finished_at).to be_nil
            expect(match.game_sets.count).to eq 3
          end

          it_behaves_like 'Redirected'
        end

        context 'And missing participant' do
          it 'Renders new template' do
            parameters['match']['participant1'] = ''

            expect(subject).to render_template :new
          end
        end

        context 'And not before hour provided, but not before minute blank' do
          it 'Sets not before minutes to 00' do
            parameters['match']['not_before(5i)'] = ''
            subject

            expect(tournament.matches.last.not_before.min).to eq 0
          end
        end

        context 'And court id of another tournament' do
          let!(:another_tournament) { FactoryBot.create(:tournament) }

          it 'Raises error' do
            parameters['match']['court_id'] = another_tournament.courts.last.id

            expect{subject}.to raise_error ActiveRecord::RecordNotFound
          end
        end

        context 'And tournament id of another tournament' do
          let!(:another_tournament) { FactoryBot.create(:tournament) }

          before :each do
            parameters['tournament_id'] = another_tournament.id
          end

          it 'Does not create new match' do
            subject

            expect(Match.count).to eq 0
          end

          it_behaves_like 'Redirecting to root'
        end
      end
    end

    context 'Without signed in user' do
      let!(:tournament) { FactoryBot.create(:tournament) }

      it_behaves_like 'Redirecting to login'
    end
  end

  describe 'GET edit' do
    subject { get :edit, params: parameters }

    context 'With signed in user' do
      let!(:user) { FactoryBot.create(:user) }

      before :each do
        sign_in user
      end

      context 'With existing tournament of that user' do
        let!(:tournament) { FactoryBot.create(:tournament, user: user) }

        context 'With existing match of that tournament' do
          let!(:match) { FactoryBot.create(:match, court: tournament.courts.first) }
          let(:parameters) { { tournament_id: tournament.id, id: match.id } }

          it 'Renders edit template' do
            expect(subject).to render_template :edit
          end

          it_behaves_like 'Responding with success'
        end

        context 'With match belonging to other tournament of other user' do
          let!(:match) { FactoryBot.create(:match) }
          let(:parameters) { { tournament_id: tournament.id, id: match.id } }

          it 'Raises error' do
            expect { subject }.to raise_error ActiveRecord::RecordNotFound
          end
        end
      end

      context 'With existing tournament and match of other user' do
        let!(:match) { FactoryBot.create(:match) }
        let(:parameters) { { tournament_id: match.tournament.id, id: match.id } }

        it_behaves_like 'Redirecting to root'
      end
    end

    context 'Without signed in user' do
      let!(:match) { FactoryBot.create(:match) }
      let(:parameters) { { tournament_id: match.tournament.id, id: match.id } }

      it_behaves_like 'Redirecting to login'
    end
  end

  describe 'PATCH update' do
    subject { patch :update, params: parameters }

    let(:parameters) do
      {
        "match" => {
          "participant1" => "Roger Federer",
          "participant2" => "Stefanos Tsitsipas",
          "court_id" => "court-id-here",
          "not_before(1i)" => "1",
          "not_before(2i)" => "1",
          "not_before(3i)" => "1",
          "not_before(4i)" => "13",
          "not_before(5i)" => "30"
        },
        "max_sets_to_play" => "5",
        "started" => "1",
        "tournament_id" => "tournament-id-here"
      }
    end

    before :each do
      parameters['tournament_id'] = tournament.id
      parameters['id'] = match.id
      parameters['match']['court_id'] = tournament.courts.last.id
    end

    context 'With signed in user' do
      let!(:user) { FactoryBot.create(:user) }

      before :each do
        sign_in user
      end

      context 'With tournament of that user' do
        let!(:tournament) { FactoryBot.create(:tournament, user: user) }

        before :each do
          parameters['tournament_id'] = tournament.id
          parameters['match']['court_id'] = tournament.courts.last.id
        end

        context 'With match of that tournament' do
          let!(:match) { FactoryBot.create(:match, court: tournament.courts.first) }

          before :each do
            parameters['id'] = match.id
          end

          it 'Updates match' do
            subject

            expect(tournament.matches.count).to eq 1
            match = tournament.matches.last
            expect(match.participant1).to eq 'Roger Federer'
            expect(match.participant2).to eq 'Stefanos Tsitsipas'
            expect(match.court_id).to eq tournament.courts.last.id
            expect(match.not_before).not_to be_nil
            expect(match.started_at).not_to be_nil
            expect(match.finished_at).to be_nil
            expect(match.game_sets.count).to eq 5
          end

          it_behaves_like 'Redirected'
        end

        context 'With match belonging to other tournament, other user' do
          let!(:match) { FactoryBot.create(:match) }

          before :each do
            parameters['tournament_id'] = match.tournament.id
            parameters['match']['court_id'] = match.tournament.courts.last.id
            parameters['id'] = match.id
          end

          it 'Does not update the match' do
            subject

            match.reload
            expect(match.participant1).not_to eq 'Roger Federer'
            expect(match.participant2).not_to eq 'Stefanos Tsitsipas'
          end

          it_behaves_like 'Redirecting to root'
        end
      end

      context 'With existing tournament and match of other user' do
        let!(:match) { FactoryBot.create(:match) }
        let(:tournament) { match.tournament }

        before :each do
          parameters['id'] = match.id
        end

        it 'Does not update the match' do
          subject

          match.reload
          expect(match.participant1).not_to eq 'Roger Federer'
          expect(match.participant2).not_to eq 'Stefanos Tsitsipas'
        end

        it_behaves_like 'Redirecting to root'
      end
    end

    context 'Without signed in user' do
      let!(:match) { FactoryBot.create(:match) }
      let(:tournament) { match.tournament }

      before :each do
        parameters['id'] = match.id
      end

      it_behaves_like 'Redirecting to login'
    end
  end

  describe 'DELETE destroy' do
    subject { delete :destroy, params: { tournament_id: tournament.id, id: match.id } }

    context 'With signed in user' do
      let!(:user) { FactoryBot.create(:user) }

      before :each do
        sign_in user
      end

      context 'Deleting a match from tournament that user owns' do
        let!(:tournament) { FactoryBot.create(:tournament, user: user) }
        let!(:match) { FactoryBot.create(:match, court: tournament.courts.first) }

        it 'Deletes the match' do
          subject

          tournament.reload
          expect(tournament.matches.count).to eq 0
        end

        it_behaves_like 'Redirected'
      end

      context 'Deleting match from tournament belonging to other user' do
        let!(:tournament) { FactoryBot.create(:tournament) }
        let!(:user_tournament) { FactoryBot.create(:tournament, user: user) }
        let!(:match) { FactoryBot.create(:match, court: user_tournament.courts.first) }

        it 'Raises error and does not delete the match' do
          expect { subject }.to raise_error ActiveRecord::RecordNotFound
          expect(Match.count).to eq 1
        end
      end

      context 'Deleting match belonging to tournament of other user' do
        let!(:tournament) { FactoryBot.create(:tournament) }
        let!(:match) { FactoryBot.create(:match, court: tournament.courts.first) }

        it 'Does not delete the match' do
          subject

          expect(Match.count).to eq 1
        end

        it_behaves_like 'Redirecting to root'
      end
    end

    context 'Without signed in user' do
      let!(:match) { FactoryBot.create(:match) }
      let(:tournament) { match.tournament }

      it_behaves_like 'Redirecting to login'
    end
  end

  describe 'GET edit_score' do
    subject { get :edit_score, params: parameters }

    context 'Match exists on given tournament' do
      let!(:court) { FactoryBot.create(:court) }
      let(:parameters) { { tournament_id: match2.tournament.id, id: match2.id } }

      context 'There is no other match being played on the court' do
        let!(:match1) { FactoryBot.create(:match, court: court) }
        let!(:match2) { FactoryBot.create(:match, court: court) }

        it 'Renders edit_score template' do
          expect(subject).to render_template :edit_score
        end
      end

      context 'There is other match being already finished on the court' do
        let!(:match1) { FactoryBot.create(:match, :finished, court: court) }
        let!(:match2) { FactoryBot.create(:match, court: court) }

        it 'Renders edit_score template' do
          expect(subject).to render_template :edit_score
        end
      end

      context 'There is other match being played on the court' do
        let!(:match1) { FactoryBot.create(:match, :started, court: court) }
        let!(:match2) { FactoryBot.create(:match, court: court) }

        it 'Redirects to court page' do
          expect(subject).to redirect_to tournament_court_url(
            tournament_id: court.tournament_id,
            id: court.id
          )
        end
      end
    end

    context 'Match does not exist on given tournament' do
      let!(:court) { FactoryBot.create(:court) }
      let!(:another_tournament_court) { FactoryBot.create(:court) }
      let!(:match) { FactoryBot.create(:match, court: another_tournament_court) }
      let(:parameters) { { tournament_id: court.tournament.id, id: match.id } }

      it 'Raises error' do
        expect{subject}.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'PATCH update_score' do

  end
end
