class CourtsController < ApplicationController
  before_action :load_tournament

  def show
    @court = Court.find(params[:id])
    @matches_updatable = policy(@court.tournament).update_matches?
    @scores_updatable = policy(@court.tournament).update_scores?
    store_location
  end


  private

  def load_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end
end
