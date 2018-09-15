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
    user&.tournament&.id == record.tournament.id
  end
end
