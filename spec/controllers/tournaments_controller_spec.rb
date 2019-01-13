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

      context 'And existing tournament of this user' do
        let!(:tournament) { FactoryBot.create(:tournament, user: user) }

        it 'Redirects to the existing tournament' do
          expect(subject).to redirect_to action: :show, id: tournament.id
        end
      end

      context 'And no existing tournament of this user' do
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

    context 'With existing tournament requested' do
      let!(:tournament) { FactoryBot.create(:tournament) }
      let(:id) { tournament.id }

      it 'Responds with status OK' do
        expect(subject).to have_http_status :ok
      end

      it 'Renders show template' do
        expect(subject).to render_template :show
      end
    end

    context 'When tournament does not exist' do
      let(:id) { 'abc' }

      it 'Responds with status OK' do
        expect(subject).to have_http_status :ok
      end

      it 'Renders show template' do
        expect(subject).to render_template :show
      end
    end
  end
end
