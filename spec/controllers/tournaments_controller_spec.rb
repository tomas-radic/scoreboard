require 'rails_helper'

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
end

RSpec.describe TournamentsController, type: :controller do
  describe "GET index" do
    subject { get :index }

    context 'With signed in user' do
      let!(:user) { FactoryBot.create(:user) }

      before :each do
        sign_in user
      end

      context 'And this user has existing open tournament' do
        let!(:tournament) { FactoryBot.create(:tournament, user: user) }

        it 'Redirects to the existing tournament' do
          expect(subject).to redirect_to action: :show, id: tournament.id
        end
      end

      context 'And this user has no existing tournament' do
        it 'Responds with status OK' do
          expect(subject).to have_http_status :ok
        end

        it 'Renders index template' do
          expect(subject).to render_template :index
        end
      end
    end

    context 'Without signed in user' do
      it 'Redirects to sign in path' do
        expect(subject).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET show' do
    subject { get :show, params: { id: id } }

    shared_examples 'Rendering show template with success' do
      it 'Responds with status OK' do
        expect(subject).to have_http_status :ok
      end

      it 'Renders show template' do
        expect(subject).to render_template :show
      end
    end

    context 'When requested tournament is existing' do
      let!(:tournament) { FactoryBot.create(:tournament) }
      let(:id) { tournament.id }

      it_behaves_like 'Rendering show template with success'
    end

    context 'When tournament does not exist' do
      let(:id) { 'abc' }

      it_behaves_like 'Rendering show template with success'
    end
  end

  describe 'GET new' do
    subject { get :new }

    context 'With signed in user' do
      let!(:user) { FactoryBot.create(:user) }

      before :each do
        sign_in user
      end

      context 'Not having a tournament currently' do
        it 'Responds with status OK' do
          expect(subject).to have_http_status :ok
        end

        it 'Renders new template' do
          expect(subject).to render_template :new
        end
      end

      context 'Having another open tournament' do
        let!(:tournament) { FactoryBot.create(:tournament, user: user) }

        it 'Redirects to root' do
          expect(subject).to redirect_to root_path
        end
      end
    end

    context 'Without signed in user' do
      it 'Redirects to login' do
        expect(subject).to redirect_to new_user_session_path(locale: nil)
      end
    end
  end

  describe 'POST create' do
    subject { post :create, params: parameters }

    let(:parameters) do
      {
        "tournament" => {
          "label" => "Wimbledon",
          "public_score_update" => "1",
          "courts_attributes" => {
            "0" => {
              "label" => "1",
              "_destroy" => "false"
            },
            "1" => {
              "label" => "2",
              "_destroy" => "false"
            },
            "2" => {
              "label" => "3",
              "_destroy" => "false"
            }
          }
        }
      }
    end

    context 'With signed in user' do
      let!(:user) { FactoryBot.create(:user) }

      before :each do
        sign_in user
      end

      context 'Not having an open tournament currently' do
        context 'With valid parameters' do
          it 'Creates new tournament for user' do
            subject
            tournament = user.reload.tournament
            expect(tournament).not_to be_nil
            expect(tournament.label).to eq 'Wimbledon'
            expect(tournament.public_score_update).to be true
            expect(tournament.courts.count).to eq 3
          end

          it 'Redirects to tournament' do
            expect(subject).to redirect_to tournament_path(user.tournament)
          end
        end

        context 'When tournament label is blank' do
          it 'Renders new template' do
            parameters['tournament']['label'] = ''

            expect(subject).to render_template :new
          end
        end
      end

      context 'Having another tournament currently open' do
        let!(:original_tournament) { FactoryBot.create(:tournament, user: user) }

        it 'Redirects to root' do
          expect(subject).to redirect_to root_path
        end

        it 'Does not create new tournament' do
          subject

          expect(user.reload.tournament.id).to eq original_tournament.id
        end
      end
    end

    context 'Without signed in user' do
      it 'Redirects to login' do
        expect(subject).to redirect_to new_user_session_path(locale: nil)
      end
    end
  end

  describe 'GET edit' do
    subject { get :edit, params: { id: tournament_id } }

    context 'With signed in user' do
      let!(:user) { FactoryBot.create(:user) }

      before :each do
        sign_in user
      end

      context 'Editing existing tournament the user owns' do
        let!(:tournament) { FactoryBot.create(:tournament, user: user) }
        let(:tournament_id) { tournament.id }

        it 'Responds with status OK' do
          expect(subject).to have_http_status :ok
        end

        it 'Renders edit template' do
          expect(subject).to render_template :edit
        end
      end

      context 'Editing tournament owned by other user' do
        let!(:tournament) { FactoryBot.create(:tournament) }
        let(:tournament_id) { tournament.id }

        it 'Redirects to root' do
          expect(subject).to redirect_to root_path
        end
      end

      context 'Editing non existing tournament' do
        let(:tournament_id) { 'abc' }

        it 'Redirects to root' do
          expect(subject).to redirect_to root_path
        end
      end
    end

    context 'Without signed in user' do
      let!(:tournament) { FactoryBot.create(:tournament) }
      let(:tournament_id) { tournament.id }

      it 'Redirects to login' do
        expect(subject).to redirect_to new_user_session_path(locale: nil)
      end
    end
  end

  describe 'PATCH update' do
    subject { patch :update, params: parameters }

    let(:headers) do
      {
        "ACCEPT" => "application/json"
      }
    end

    let(:parameters) do
      {
        "tournament" => {
          "label" => "Wimbledon",
          "public_score_update" => "0",
          "courts_attributes" => {
            "0" => {
              "label" => "1",
              "_destroy" => "false"
            },
            "1" => {
              "label" => "2",
              "_destroy" => "true"
            },
            "2" => {
              "label" => "3",
              "_destroy" => "false"
            }
          }
        }
      }
    end

    context 'With signed in user' do
      let!(:user) { FactoryBot.create(:user) }

      before :each do
        sign_in user
      end

      context 'Updating existing tournament the user owns' do
        let!(:tournament) { FactoryBot.create(:tournament, user: user) }
        let(:tournament_id) { tournament.id }

        before :each do
          parameters['id'] = tournament.id
          parameters['tournament']['courts_attributes']['0']['id'] = tournament.courts.find_by(label: '1').id
          parameters['tournament']['courts_attributes']['1']['id'] = tournament.courts.find_by(label: '2').id
          parameters['tournament']['courts_attributes']['2']['id'] = tournament.courts.find_by(label: '3').id
        end

        context 'With valid parameters' do
          it 'Updates the tournament' do
            subject

            tournament = user.reload.tournament
            expect(tournament.label).to eq 'Wimbledon'
            expect(tournament.public_score_update).to be false
            expect(tournament.courts.pluck :label).to match_array ['1', '3']
          end

          it 'Redirects to tournament' do
            expect(subject).to redirect_to tournament_path(user.tournament)
          end
        end

        context 'When tournament label is blank' do
          it 'Renders edit template' do
            parameters['tournament']['label'] = ''

            expect(subject).to render_template :edit
          end
        end
      end

      context 'Updating tournament owned by another user' do
        let!(:tournament) { FactoryBot.create(:tournament) }
        let(:tournament_id) { tournament.id }

        before :each do
          parameters['id'] = tournament.id
        end

        it 'Redirects to root' do
          expect(subject).to redirect_to root_path
        end

        it 'Does not update the tournament' do
          subject
          tournament.reload

          expect(tournament.label).not_to eq 'Wimbledon'
          expect(tournament.courts.count).to eq 3
        end
      end

      context 'Updating non existing tournament' do
        before :each do
          parameters['id'] = 'abc'
        end

        it 'Redirects to root' do
          expect(subject).to redirect_to root_path
        end
      end
    end

    context 'Without signed in user' do
      let!(:tournament) { FactoryBot.create(:tournament) }

      before :each do
        parameters['id'] = tournament.id
      end

      it 'Redirects to login' do
        expect(subject).to redirect_to new_user_session_path(locale: nil)
      end
    end
  end

  describe 'DELETE destroy' do
    subject { delete :destroy, params: { id: tournament_id } }

    let(:headers) do
      {
        "ACCEPT" => "application/json"
      }
    end

    context 'With signed in user' do
      let!(:user) { FactoryBot.create(:user) }

      before :each do
        sign_in user
      end

      context 'Deleting existing tournament the user owns' do
        let!(:tournament) { FactoryBot.create(:tournament, user: user) }
        let(:tournament_id) { tournament.id }

        it 'Deletes the tournament' do
          subject

          expect(Tournament.count).to eq 0
        end

        it 'Redirects to tournaments#index' do
          expect(subject).to redirect_to tournaments_path
        end
      end

      context 'Deleting existing tournament owned by other user' do
        let!(:tournament) { FactoryBot.create(:tournament) }
        let(:tournament_id) { tournament.id }

        it 'Does not delete the tournament' do
          subject

          expect(Tournament.last.id).to eq tournament.id
        end

        it 'Redirects to root' do
          expect(subject).to redirect_to root_path
        end
      end

      context 'Deleting non existing tournament' do
        let(:tournament_id) { 'abc' }

        it 'Redirects to root' do
          expect(subject).to redirect_to root_path
        end
      end
    end

    context 'Without signed in user' do
      let!(:tournament) { FactoryBot.create(:tournament) }
      let(:tournament_id) { tournament.id }

      it 'Does not delete the tournament' do
        expect(Tournament.last.id).to eq tournament.id
      end

      it 'Redirects to login' do
        expect(subject).to redirect_to new_user_session_path(locale: nil)
      end
    end
  end

  describe 'GET refresh_score' do
    subject { get :refresh_score, params: { id: tournament.id }, xhr: true }

    let!(:tournament) { FactoryBot.create(:tournament) }

    it 'Responds with JS' do
      subject

      expect(response.content_type).to eq('text/javascript')
    end
  end
end
