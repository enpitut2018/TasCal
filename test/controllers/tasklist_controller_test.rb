# coding: utf-8
require 'test_helper'

class TasklistControllerTest < ActionDispatch::IntegrationTest
  test "should get insert" do
    get tasklist_insert_url
    assert_response :success
    assert_equal (Tasklist.get_tasks.empty?) , true , "タスク空か?"
    assert_difference 'Tasklist.get_task_count' , 1 , "タスクカウントが増えたか？" do
      post tasklist_insert_url , params: 
                                { 
                                  name: "hoge", 
                                  date: "fuga"
                                }
    end
    assert_equal (Tasklist.get_tasks.empty?) , false , "タスクに追加されたか?"
    # assert_template 'tasklist/insert'
     # end
    # post :create 
    # assert_response :seccess
    # assert_template "tasklist/insert"

    # assert_equal (shops_count_before_create +1), Shop.count
  end

  test "should get delete" do
    get tasklist_delete_url
    assert_response :success
  end

  # test "should get display" do
  #   get tasklist_display_url
  #   assert_response :success
  # end

end
