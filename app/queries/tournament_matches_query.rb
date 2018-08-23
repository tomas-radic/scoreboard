class TournamentMatchesQuery < Patterns::Query
  queries Match

  private

  def query
    Pundit.policy_scope(user, relation).unscoped
        .includes(:game_sets)
        .order(:completed_at, :started_at)
        .order('matches.position asc')
  end

  def user
    options.fetch(:user)
  end
end
