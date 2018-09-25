class Users::RegistrationsController < Devise::RegistrationsController
  include Internationalization

  before_action :set_locale
end
