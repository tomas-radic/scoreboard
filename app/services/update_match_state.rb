class UpdateMatchState < Patterns::Service
  pattr_initialize :match, :score, :finished

  def call
    init

    ActiveRecord::Base.transaction do
      update_match_score!
      update_match_state!
      match.finished_at.nil?
    end
  end

  private

  def init
    @games_played = 0
    @state_attrs = {}
  end

  def update_match_score!
    match.game_sets.each do |game_set|
      set_score = score[(game_set.position - 1).to_s]
      next if set_score.nil? || set_score.reject(&:blank?).empty?

      save_set_score! game_set, set_score
    end
  end

  def save_set_score!(game_set, set_score)
    raise 'Invalid set score' unless set_score.length == 2

    set_score.map!(&:to_i)
    @games_played += set_score.sum
    game_set.update! score: set_score
  end

  def update_match_state!
    calculate_start_time if match.started_at.nil?
    set_finish_time
    save_match_state!
  end

  def calculate_start_time
    minutes_played = @games_played * 5
    @state_attrs[:started_at] = minutes_played.minutes.ago
  end

  def set_finish_time
    if finished
      @state_attrs[:finished_at] = Time.zone.now unless match.finished?
    else
      @state_attrs[:finished_at] = nil
    end
  end

  def save_match_state!
    match.update! @state_attrs
  end
end
