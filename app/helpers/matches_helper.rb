module MatchesHelper
  def row_for(match)

    content_tag :tr, class: decoration_class_for(match) do
      result = content_tag :td do
        check_box_tag :finished, :finished, match.finished?, disabled: true
      end

      result += content_tag :td do
        match.label
      end

      result += content_tag :td do
        match.court.label
      end

      result += content_tag :td do
        Score.result_for match
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
end
