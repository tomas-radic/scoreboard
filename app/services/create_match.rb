class CreateMatch < Patterns::Service
  include MatchUpdating
  pattr_initialize :tournament, :attributes
  attr_reader :match

  def call
    verify_court!

    @match = Match.new
    preprocess_attributes
    assign_attributes
    assign_game_sets
    set_match_state
    match.save
  end
end
