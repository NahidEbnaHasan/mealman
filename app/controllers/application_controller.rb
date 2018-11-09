class ApplicationController < ActionController::Base
  before_action :set_current_user

  def after_sign_in_path_for(_resource)
    home_path
  end

  def set_current_user
    @_current_user ||= current_user
  end
end
