module TaskHelper

  def get_available_tasks
    if user_signed_in? then
      Task.where(:user_id => current_user.email)
    else
      Task.where(:user_id => nil)
    end
  end

end
