class Users::SessionsController < Devise::SessionsController
  include Internationalization

  before_action :set_locale
end
