class CreateMatch < Patterns::Service
  include Pundit
  include MatchUpdating
  pattr_initialize :tournament, :attributes
  attr_reader :match

  def call
    verify_court!

    @match = Match.new
    authorize @match, :create?

    preprocess_attributes
    assign_attributes
    assign_game_sets
    set_match_state
    match.save
    match
  end

  def pundit_user
    tournament.user
  end
end
