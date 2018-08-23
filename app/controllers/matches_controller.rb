class MatchesController < ApplicationController
  def index
    authorize Match
    @matches = TournamentMatchesQuery.call(user: current_user)
  end
end
