module MatchUpdating
  extend ActiveSupport::Concern

  private

  def assign_attributes
    match.assign_attributes permitted_attributes
  end

  def permitted_attributes
    attributes.require(:match).permit(
      'participant1', 'participant2',
      'not_before(1i)',
      'not_before(2i)',
      'not_before(3i)',
      'not_before(4i)',
      'not_before(5i)'
    )
  end

  def preprocess_attributes
    if attributes[:match]['not_before(4i)'].blank?
      attributes[:match]['not_before(1i)'] = ""
      attributes[:match]['not_before(2i)'] = ""
      attributes[:match]['not_before(3i)'] = ""
      attributes[:match]['not_before(4i)'] = ""
      attributes[:match]['not_before(5i)'] = ""
    elsif attributes[:match]['not_before(5i)'].blank?
      attributes[:match]['not_before(5i)'] = '00'
    end
  end

  def assign_game_sets
    max_sets_to_play = attributes[:max_sets_to_play].to_i
    max_sets_to_play = 3 unless [1, 3, 5].include? max_sets_to_play

    game_sets_to_create = max_sets_to_play - match.game_sets.count
    game_sets_to_create.times do
      match.game_sets << GameSet.new
    end
  end

  def set_match_state
    now = Time.zone.now
    if attributes[:started] == '1'
      match.started_at ||= now
    else
      match.started_at = nil
    end

    if attributes[:finished] == '1'
      match.finished_at ||= now
    else
      match.finished_at = nil
    end
  end

  def assign_court
    match.court = court
  end

  def court
    @court ||= tournament.courts.find attributes[:match][:court_id]
  end
end
