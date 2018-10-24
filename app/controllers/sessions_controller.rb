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
end
