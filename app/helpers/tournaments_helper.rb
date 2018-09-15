module TournamentsHelper
  def court_label_for(match)
    "#{match.participant1}<br>vs<br>#{match.participant2}".html_safe
  end
end
