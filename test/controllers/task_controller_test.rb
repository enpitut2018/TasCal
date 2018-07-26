# coding: utf-8
require 'test_helper'

class TaskControllerTest < ActionDispatch::IntegrationTest
  def setup
    Task.destroy_all
  end

  test "should get insert" do
    get task_insert_url
    assert_response :success
    assert_equal (Task.where("id > 0").count) , 0 , "タスク空か?"    
    assert_difference 'Task.where("id > 0").count' , 1 , "タスクカウントが増えたか？" do
      post task_insert_url , params: 
    { 
      name: "hoge", 
      year: "2018",
      month:"07",
      day:"25",
      hour:"12",
      minute:"00"
    }
    end
    assert_equal (Task.where("id > 0").count = 0) , false , "タスクに追加されたか?"

  end

  test "should get display" do
    get task_display_url
    assert_response :success
  end

  # test "should get delete" do
  #   get task_delete_url
  #   assert_response :success
  # end

end
