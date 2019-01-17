require 'google/api_client/client_secrets.rb'
class SessionsController < ApplicationController
  def login
    redirect_to user_google_omniauth_authorize_path
  end
  
  def logout
    if current_user then
      sign_out_and_redirect current_user
    else
      redirect_to "/"
    end
  end
  def import
    #if current_user
    @user_info = request.env['omniauth.auth']
    secrets = Google::APIClient::ClientSecrets.new(
      web: {
        access_token:  @user_info.credentials.token,
        refresh_token: @user_info.credentials.refresh_token,
        client_id:     ENV['GOOGLE_CLIENT_ID'],
        client_secret: ENV['GOOGLE_SECRET']
      }
    )

    cal_service = Google::Apis::CalendarV3::CalendarService.new
    cal_service.authorization = secrets.to_authorization
    @calendar_list = cal_service.list_calendar_lists
    ScheduleController.import @calendar_list
    #end
    redirect_to "/"
  end
end
