class MatchPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.tournament.present?
        user.tournament.matches
      else
        scope.none
      end
    end
  end

  def index?
    user.present?
  end
end
