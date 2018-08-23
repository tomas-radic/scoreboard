class TournamentMatchesQuery < Patterns::Query
  queries Match

  private

  def query
    Pundit.policy_scope(user, relation)
        .includes(:game_sets)
        .order(:finished_at, :started_at, :position)
  end

  def user
    options.fetch(:user)
  end
end
