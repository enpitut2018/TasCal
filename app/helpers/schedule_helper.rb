module ScheduleHelper

  def get_available_schedules
    if user_signed_in? then
      Schedule.where(:user_id => current_user.email)
    else
      Schedule.where(:user_id => nil)
    end
  end

end
