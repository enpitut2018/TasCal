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
    if current_user then
      redirect_to user_google_omniauth_authorize_path
    else
      redirect_to "/"
    end
  end
end
