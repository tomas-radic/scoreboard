module TournamentsHelper
  def tournament_header_for(tournament)
    if tournament.present? && policy(tournament).manage?
      render 'shared/manager_header'
    else
      render 'shared/participant_header'
    end
  end

  def court_label_for(match)
    "#{match.participant1}<br>vs<br>#{match.participant2}".html_safe
  end
end
