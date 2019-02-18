require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google
    user_info = request.env['omniauth.auth']
    @user = User.find_for_google(user_info)

    logger.debug("Persisted: %s" % @user.persisted?)
    p "login-callback"
    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      secrets = Google::APIClient::ClientSecrets.new(
        web: {
          access_token:  user_info.credentials.token,
          refresh_token: user_info.credentials.refresh_token,
          client_id:     ENV['GOOGLE_CLIENT_ID'],
          client_secret: ENV['GOOGLE_CLIENT_SECRET'],
          scope: Google::Apis::CalendarV3::AUTH_CALENDAR
        }
      )

      cal_service = Google::Apis::CalendarV3::CalendarService.new
      cal_service.authorization = secrets.to_authorization
      @calendar_list = cal_service.list_calendar_lists
      p @calendar_list
      #ScheduleController.import @calendar_list

      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end
