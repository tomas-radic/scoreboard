module MatchesHelper
  def handle_cell_for(match, draggable:)
    content_tag :td, class: draggable ? 'drag-handle' : '' do
      if draggable
        fa_icon 'bars'
      elsif match.finished?
        fa_icon 'check'
      end
    end
  end

  def label_cell_for(match, editable:)
    content_tag :td do
      if editable
        link_to match.label, edit_tournament_match_path(match.tournament, match)
      else
        match.label
      end
    end
  end

  def score_cell_for(match, editable:)
    content_tag :td do
      if editable
        link_to(Score.result_for(match), edit_score_tournament_match_path(match.tournament, match), class: 'btn btn-sm btn-success') + " <small><i>#{latest_score_update match, true}</i></small>".html_safe
      else
        "#{Score.result_for(match)} <small><i>#{latest_score_update match, true}</i></small>".html_safe
      end
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
    result += " (#{match.started_at.in_time_zone.strftime('%H:%M')})" if match.started_at.present?
    result
  end

  def match_finished_label(match)
    result = t '.match_finished'
    result += " (#{match.finished_at.in_time_zone.strftime('%H:%M')})" if match.finished_at.present?
    result
  end

  def latest_score_update(match, bracket = false)
    latest_update_at = match.game_sets.map do |game_set|
      game_set.updated_at unless game_set.score.empty?
    end.compact.max

    return '' if latest_update_at.blank?

    minutes_ago = ((Time.zone.now - latest_update_at) / 60).ceil

    if minutes_ago >= 60
      bracket ? '(>60m)' : '>60m'
    elsif bracket
      t('latest_score_update_bracket_html', minutes: minutes_ago)
    else
      t('latest_score_update_html', minutes: minutes_ago)
    end
  end
end
