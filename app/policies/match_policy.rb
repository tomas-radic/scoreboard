class MatchPolicy < ApplicationPolicy
  def create?
    user&.tournament.present?
  end

  def update?
    record_belongs_to_user?
  end

  def destroy?
    record_belongs_to_user?
  end

  private

  def record_belongs_to_user?
    user&.tournament&.id == record.tournament.id
  end
end
