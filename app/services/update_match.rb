class UpdateMatch < Patterns::Service
  include MatchUpdating
  pattr_initialize :match, :attributes
  attr_reader :tournament

  def call
    @tournament = match.tournament

    preprocess_attributes
    assign_attributes
    assign_court
    assign_game_sets
    set_match_state
    match.save
    match
  end
end
