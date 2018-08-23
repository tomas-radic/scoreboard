module TournamentsHelper
  def tournament_header_for(tournament)
    if policy(tournament).manage?
      render 'manager_header'
    else
      render 'participant_header'
    end
  end
end
