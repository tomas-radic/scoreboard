class MatchPolicy < ApplicationPolicy
  def new?
    create?
  end

  def create?
    user.present?
  end

  def edit?
    update?
  end

  def update?
    user.present? && user.tournament.try(:id) == record.tournament.id
  end
end
