class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :get_current_user_avator, :get_current_user_id, :is_logged_in

  # 未ログイン時にaboutページに強制的にリダイレクトさせる
  before_action :require_login
  def require_login

    # テスト実行時(ホスト名が "www.example.com" の場合)はリダイレクト処理を行わない
    return if request.host == "www.example.com"

    unless current_user
      if !(params[:controller] == "static" && params[:action] == "about") \
      && params[:controller] != "sessions" \
      && params[:controller] != "users/omniauth_callbacks" # sessions と users/omniauth_callback はログイン処理中に処理を行うController
        redirect_to "/about"
      end
    end
  end

  # 以下の2つのリクエストを "https"//tascal.app" にリダイレクトさせる
  # - "https://enpit-tascal.herokuapp.com"
  # - "https://www.tascal.app"
  before_action :ensure_domain
  def ensure_domain

    # テスト実行時(ホスト名が "www.example.com" の場合)はリダイレクト処理を行わない
    return if request.host == "www.example.com"

    return unless /\.herokuapp.com/ =~ request.host || /^www./ =~ request.host

    fqdn = 'tascal.app'

    # 主にlocalテスト用の対策80と443以外でアクセスされた場合ポート番号をURLに含める
    port = ":#{request.port}" unless [80, 443].include?(request.port)
    redirect_to "#{request.protocol}#{fqdn}#{port}#{request.path}", status: :moved_permanently
  end

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