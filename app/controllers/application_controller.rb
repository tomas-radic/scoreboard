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
    return if @tournament.blank?
    matches_count = @tournament.matches.count
    return unless matches_count > 0

    finished_percentage = ((@tournament.matches.finished.count * 100) / matches_count).round
    in_progress_percentage = ((@tournament.matches.in_progress.count * 100) / matches_count).round
    upcoming_percentage = 100 - finished_percentage - in_progress_percentage
    @tournament_progress = {
      finished: finished_percentage,
      in_progress: in_progress_percentage,
      upcoming: upcoming_percentage
    }
  end

  def default_url_options
    { locale: I18n.locale }
  end


  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def self.default_url_options(options={})
    options.merge({ :locale => I18n.locale })
  end
end
