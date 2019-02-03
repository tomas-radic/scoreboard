class MatchesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :edit_score, :update_score]
  before_action :load_tournament_or_redirect
  before_action :load_match, only: [:edit, :update, :edit_score, :update_score, :destroy]
  before_action :preprocess_params, only: [:create, :update]
  before_action :set_tournament_progress

  def index
    @matches = @tournament.matches.sorted
    @matches_updatable = policy(@tournament).update_matches?
    @scores_updatable = policy(@tournament).update_scores?
    @court_public_keys = @tournament.courts.map(&:public_key)
    store_location
  end

  def new
    @match = Match.new(
      court_id: params[:court_id],
      game_sets: [
        GameSet.new,
        GameSet.new,
        GameSet.new
      ]
    )

    authorize @match
    @back_path = stored_location(fallback: tournament_path(@tournament))
  end

  def create
    # authorization handled in service object
    @match = CreateMatch.call(current_user.tournament, params).result

    if @match.errors.blank?
      redirect_to(stored_location(fallback: tournament_matches_path(@tournament))) and forget_location
    else
      @back_path = stored_location(fallback: tournament_path(@tournament))
      render :new
    end
  end

  def edit
    authorize @match
    @back_path = stored_location(fallback: tournament_path(@tournament))
  end

  def update
    authorize @match
    UpdateMatch.call(@match, params)

    if @match.errors.blank?
      redirect_to(stored_location(fallback: tournament_matches_path(@tournament))) and forget_location
    else
      @back_path = stored_location(fallback: tournament_path(@tournament))
      render :edit
    end
  end

  def destroy
    authorize @match

    @match.destroy
    redirect_to stored_location(fallback: tournament_path(@tournament))
  end

  def edit_score
    @back_path = stored_location(fallback: tournament_path(@tournament))
    @game_sets_count = @match.game_sets.count
  end

  def update_score
    begin
      back_to_edit_score = UpdateMatchState.call(
        @match,
        params[:score],
        params['finished'].present?
      ).result

      if back_to_edit_score
        redirect_to edit_score_tournament_match_path(@tournament, @match)
      else
        redirect_to tournament_matches_path @tournament
      end
    rescue ActiveRecord::RecordInvalid
      redirect_to tournament_court_path @tournament, @match.court
    end
  end


  private

  def load_tournament_or_redirect
    @tournament = Tournament.find_by(id: params[:tournament_id])

    unless @tournament.present?
      redirect_to tournament_path(id: params[:tournament_id]) and return
    end
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
