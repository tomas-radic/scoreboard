class TournamentMatchesQuery < Patterns::Query
  queries Match

  private

  def query
    tournament.matches
        .includes(:court, :game_sets)
        .order(:finished_at, :started_at, :position)
  end

  def tournament
    options.fetch(:tournament)
  end
end
