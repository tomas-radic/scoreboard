class CourtDecorator < SimpleDelegator
  def available_for?(match, court_occupations)
    return true if match.in_progress? || match.finished?
    court_occupations[match.court_id].nil?
  end
end
