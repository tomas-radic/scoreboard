module CourtsHelper
  def court_matches_row_for(match, match_update_allowed, score_update_allowed)
    content_tag :tr, class: decoration_class_for(match) do
      result = content_tag :td do
        check_box_tag :finished, :finished, match.finished?, disabled: true
      end

      if match_update_allowed
        result += content_tag :td do
          link_to match.label, edit_tournament_match_path(match.tournament, match)
        end
      else
        result += content_tag :td do
          match.label
        end
      end

      if score_update_allowed
        result += content_tag :td do
          link_to Score.result_for(match), edit_score_tournament_match_path(match.tournament, match)
        end
      else
        result += content_tag :td do
          Score.result_for match
        end
      end

      result += content_tag :td do
        NotBeforeInfo.result_for match
      end

      result
    end
  end
end
