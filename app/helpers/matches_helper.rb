module MatchesHelper
  def all_matches_row_for(match)
    render_organizer = user_signed_in? && policy(current_user.tournament).manage?

    content_tag :tr, class: decoration_class_for(match) do
      result = content_tag :td do
        check_box_tag :finished, :finished, match.finished?, disabled: true
      end

      if render_organizer
        result += content_tag :td do
          link_to match.label, edit_tournament_match_path(match.tournament, match)
        end
      else
        result += content_tag :td do
          match.label
        end
      end

      result += content_tag :td do
        match.court.label
      end

      if render_organizer
        result += content_tag :td do
          link_to Score.result_for(match), edit_score_tournament_match_path(match.tournament, match)
        end
      else
        result += content_tag :td do
          Score.result_for(match)
        end
      end

      result += content_tag :td do
        NotBeforeInfo.result_for match
      end

      result
    end
  end

  def decoration_class_for(match)
    if match.finished?
      'table-secondary'
    elsif match.started?
      'table-warning'
    else
      'table-success'
    end
  end

  def match_started_label(match)
    result = "Match started"
    result += " (#{match.started_at.localtime.strftime('%k:%M')})" if match.started?
    result
  end

  def match_finished_label(match)
    result = "Match finished"
    result += " (#{match.finished_at.localtime.strftime('%k:%M')})" if match.finished?
    result
  end

  def latest_score_update(match)
    latest_update_at = match.game_sets.where.not(score: []).pluck(:updated_at).max
    return 'unknown score' if latest_update_at.blank?

    minutes_ago = ((Time.zone.now - latest_update_at) / 60).ceil

    if minutes_ago >= 60
      '>60m'
    else
      content_tag(:span, minutes_ago, class: 'score-time-info') + 'm ago'
    end
  end
end
