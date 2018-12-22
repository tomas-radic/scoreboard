class CourtsController < ApplicationController
  before_action :load_records_or_redirect
  before_action :set_tournament_progress

  def show
    @court_public_keys = [@court.public_key]
    store_location
  end

  def reorder_matches
    # params[:matchPositionsOrder] comes like ['3', '1', '2', '4'] and we want to save
    # positions in this order

    @court.matches.sorted.each do |match|
      match.set_list_position(params[:matchPositionsOrder].index(match.position.to_s) + 1)
      match.save
    end

    respond_to do |format|
      format.js
    end
  end


  private

  def load_records_or_redirect
    @tournament = Tournament.find_by(id: params[:tournament_id])

    unless @tournament.present?
      redirect_to_root
      return
    end

    @court = @tournament.courts.find(params[:id])
    @matches_updatable = policy(@court.tournament).update_matches?
    @scores_updatable = policy(@court.tournament).update_scores?
  end
end
