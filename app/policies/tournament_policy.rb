class TournamentPolicy < ApplicationPolicy
  def manage?
    return false unless user.present?
    record.user_id == user.id
  end

  def create?
    user.present? && user.tournament.nil?
  end

  def new?
    create?
  end

  def update?
    manage?
  end

  def edit?
    update?
  end

  def destroy?
    manage?
  end

  def update_matches?
    user.present? && record.id == user.tournament.id
  end

  def update_scores?
    update_matches? || record.public_score_update?
  end
end
