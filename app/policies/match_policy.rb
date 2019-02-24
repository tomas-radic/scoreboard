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

  def edit_score?
    update_score?
  end

  def update_score?
    public_score_update? || record_belongs_to_user?
  end

  private

  def record_belongs_to_user?
    user&.tournament&.id == record.tournament.id
  end

  def public_score_update?
    record.tournament.public_score_update?
  end
end
