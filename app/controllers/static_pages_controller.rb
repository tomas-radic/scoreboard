class StaticPagesController < ApplicationController
  def about
    if user_signed_in?
      @tournament = current_user.tournament
    end
  end
end
