class CreateMatch < Patterns::Service
  include MatchUpdating
  pattr_initialize :tournament, :attributes
  attr_reader :match

  def call
    @match = Match.new

    preprocess_attributes
    assign_attributes
    assign_court
    assign_game_sets
    set_match_state
    match.save
    match
  end
end
