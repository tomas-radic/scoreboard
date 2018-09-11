class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    tournaments_path
  end

  def store_location
    session[:stored_location] = request.url
  end

  def forget_location
    session.delete :stored_location
  end

  def stored_location
    session[:stored_location]
  end
end
