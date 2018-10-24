class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :get_current_user_avator, :get_current_user_id, :is_logged_in

  private
  def get_current_user_avator
    if current_user then
      current_user.avatar_url
    else
      nil
    end
  end

  private
  def get_current_user_id
    if current_user then
      current_user.email
    else
      nil
    end
  end

end