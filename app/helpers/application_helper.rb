module ApplicationHelper
  include Devise::Controllers::Helpers

  def current_user
    @current_user
  end

  def signed_in?
    user_signed_in?
  end
end
