module MatchesHelper
  def all_matches_row_for(match, update_allowed, score_update_allowed)
    content_tag :tr, class: decoration_class_for(match) do
      result = content_tag :td do
        check_box_tag :finished, :finished, match.finished?, disabled: true
      end

      if update_allowed
        result += content_tag :td do
          link_to match.label, edit_tournament_match_path(match.tournament, match)
        end
      else
        result += content_tag :td do
          match.label
        end
      end

      result += content_tag :td do
        link_to match.court.label, tournament_court_path(match.tournament, match.court)
      end

      if score_update_allowed
        result += content_tag :td do
          link_to Score.result_for(match), edit_score_tournament_match_path(match.tournament, match), class: 'btn btn-sm btn-success'
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
      'color-dust'
    elsif match.started?
      'background-highlight'
    else
      'background-clay-dark'
    end
  end

  def match_started_label(match)
    result = t '.match_started'
    result += " (#{match.started_at.localtime.strftime('%H:%M')})" if match.started_at.present?
    result
  end

  def match_finished_label(match)
    result = t '.match_finished'
    result += " (#{match.finished_at.localtime.strftime('%H:%M')})" if match.finished_at.present?
    result
  end

  def latest_score_update(match)
    latest_update_at = match.game_sets.where.not(score: []).pluck(:updated_at).max
    return 'unknown score' if latest_update_at.blank?

    minutes_ago = ((Time.zone.now - latest_update_at) / 60).ceil

    if minutes_ago >= 60
      '>60m'
    else
      t('latest_score_update_html', minutes: minutes_ago)
      # content_tag(:span, minutes_ago, class: 'score-time-info') + 'm ago'
    end
  end
end
