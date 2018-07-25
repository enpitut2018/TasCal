# coding: utf-8
require 'test_helper'

class TasklistControllerTest < ActionDispatch::IntegrationTest
  def setup
    Tasklist.cleanup
  end

  test "should get insert" do
    get tasklist_insert_url
    assert_response :success
    assert_equal (Tasklist.get_tasks.empty?) , true , "タスク空か?"
    assert_difference 'Tasklist.get_task_count' , 1 , "タスクカウントが増えたか？" do
      post tasklist_insert_url , params: 
    { 
      name: "hoge", 
      year: "2018",
      month:"07",
      day:"25",
      hour:"12",
      minute:"00"
    }
    end
    assert_equal (Tasklist.get_tasks.empty?) , false , "タスクに追加されたか?"
    # assert_template 'tasklist/insert'
    #  end
    # post :create 
    # assert_response :seccess
    # assert_template "tasklist/insert"

    # assert_equal (shops_count_before_create +1), Shop.count
  end

  test "should pass validation" do
    post tasklist_insert_url , params: 
    { 
      name: "hoge", 
      year: "2018",
      month:"07",
      day:"25",
      hour:"12",
      minute:"00"
    }
    assert_redirected_to tasklist_display_url, "一覧画面にリダイレクトされる．"    
  end

  test "should reject validation" do
    post tasklist_insert_url , params: 
    { 
      name: "hoge", 
      year: "",
      month:"07",
      day:"25",
      hour:"12",
      minute:"00"
    }
    assert_equal (Tasklist.get_tasks.empty?) , true , "タスクが増えていないか?"
    assert_response 400, "リクエストが不正です"
  end

  test "should get delete" do

    post tasklist_insert_url , params: 
    { 
      name: "hoge", 
      year: "2018",
      month:"07",
      day:"25",
      hour:"12",
      minute:"00"
    }

    assert_difference 'Tasklist.get_task_count' , -1 , "タスクカウントが減ったか？" do
      post tasklist_delete_url, params: 
      { 
        id: "0"
      }
      assert_redirected_to tasklist_display_url
    end
    assert_equal (Tasklist.get_tasks.empty?) , true , "タスクが削除されたか?"
  end

  # test "should get display" do
  #   get tasklist_display_url
  #   assert_response :success
  # end

end
