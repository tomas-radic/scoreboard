class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  before_action :set_locale

  def after_sign_in_path_for(resource)
    tournaments_path
  end

  def store_location
    session[:stored_location] = request.url
  end

  def forget_location
    session.delete :stored_location
  end

  def stored_location(fallback:)
    session[:stored_location] || fallback
  end

  def set_tournament_progress
    @tournament_progress = calculate_tournament_progress
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def redirect_to_root
    if user_signed_in?
      redirect_to root_path and return
    else
      redirect_to new_user_session_path and return
    end
  end


  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def calculate_tournament_progress
    return nil if @tournament.blank?
    matches_count = @tournament.matches.count
    return nil unless matches_count > 0

    matches_count = matches_count.to_f

    finished_percentage = ((@tournament.matches.finished.count * 100) / matches_count).round
    in_progress_percentage = ((@tournament.matches.in_progress.count * 100) / matches_count).round
    upcoming_percentage = ((@tournament.matches.upcoming.count * 100) / matches_count).round

    rounding_difference = 100 - finished_percentage - in_progress_percentage - upcoming_percentage
    if rounding_difference > 0
      if upcoming_percentage > 0
        upcoming_percentage += rounding_difference
      elsif in_progress_percentage > 0
        in_progress_percentage += rounding_difference
      elsif finished_percentage > 0
        finished_percentage += rounding_difference
      end
    end

    {
      finished: finished_percentage,
      in_progress: in_progress_percentage,
      upcoming: upcoming_percentage
    }
  end
end
