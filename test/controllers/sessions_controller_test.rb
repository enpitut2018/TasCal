require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  test 'should not get login' do
    # ログイン用のURLは "/login" に設定されており， "/sessions/login" は使用できない
    assert_raises(ActionController::RoutingError) do
      get '/sessions/login'
    end
  end

  test 'should not get logout' do
    # ログアウト用のURLは "/logout" に設定されており， "/sessions/logout" は使用できない
    assert_raises(ActionController::RoutingError) do
      get '/sessions/logout'
    end
  end

  test 'should be redirected to google authentication page' do
    # ログイン用のURLにアクセスするとGoogleの認証ページにリダイレクトされる
    get '/login'
    assert_response :redirect
  end

  test 'should get logout' do
    # ログアウト用のURLに（未ログイン状態で）アクセスするとトップページにリダイレクトされる
    get '/logout'
    assert_response :redirect
  end

end
