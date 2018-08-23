class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    tournaments_path
  end
end
