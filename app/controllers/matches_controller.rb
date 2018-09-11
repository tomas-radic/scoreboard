class MatchesController < ApplicationController
  before_action :load_tournament
  before_action :load_match, only: [:edit, :update, :edit_score, :update_score, :destroy]
  before_action :preprocess_params, only: [:create, :update]

  def index
    @matches = TournamentMatchesQuery.call(tournament: @tournament)
    store_location
  end

  def new
    @match = Match.new(
      game_sets: [
        GameSet.new,
        GameSet.new,
        GameSet.new
      ]
    )

    authorize @match
  end

  def create
    authorize(Match)

    if CreateMatch.call(current_user.tournament, params)
      redirect_to(stored_location || tournament_matches_path(@tournament)) and forget_location
    else
      render :new
    end
  end

  def edit
    authorize @match
  end

  def update
    authorize @match

    if UpdateMatch.call(@match, params)
      redirect_to(stored_location || tournament_matches_path(@tournament)) and forget_location
    else
      render :edit
    end
  end

  def destroy

  end

  def edit_score
  end

  def update_score
    if UpdateMatchState.call(@match, params[:score], params['finished'].present?).result
      redirect_to edit_score_tournament_match_path(@tournament, @match)
    else
      redirect_to tournament_path @tournament
    end
  end


  private

  def load_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def load_match
    @match = @tournament.matches.find(params[:id])
  end

  def preprocess_params
    if params[:match]['not_before(4i)'].blank?
        params[:match]['not_before(1i)'] = ""
        params[:match]['not_before(2i)'] = ""
        params[:match]['not_before(3i)'] = ""
        params[:match]['not_before(4i)'] = ""
        params[:match]['not_before(5i)'] = ""
    end
  end
end
