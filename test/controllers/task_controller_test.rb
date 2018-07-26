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
    assert_equal (Task.where("id > 0").count == 1) , true , "タスクに追加されたか?"
  end

  test "should reject empty input" do
    post task_insert_url , params: 
    { 
      name: "hoge", 
      year: "",
      month:"07",
      day:"25",
      hour:"12",
      minute:"00"
    }
    assert_equal (Task.where("id > 0").count == 0) , true , "空のとき、タスクが増えていないか?"
    assert_response 400, "空のとき、リクエストが不正ですと出る"
  end

  test "should reject invalid date input" do
    post task_insert_url , params:
        {
            name: "hoge",
            year: "2018",
            month:"07",
            day:"40",
            hour:"12",
            minute:"00"
        }
    assert_equal (Task.where("id > 0").count == 0) , true , "不正な日付のときタスクが増えていないか?"
    assert_response 400, "不正な日付のときリクエストが不正です"
  end

  test "should get display" do
    get task_display_url
    assert_response :success
  end

  test "should get delete" do
    # get task_delete_url
    # assert_response :success
    post task_insert_url , params: 
    { 
      name: "hoge", 
      year: "2018",
      month:"07",
      day:"25",
      hour:"12",
      minute:"00"
    }
    id = Task.find_by(name: "hoge").id
    assert_difference 'Task.where("id > 0").count' , -1 , "タスクカウントが減ったか？" do
      post task_delete_url, params: 
      { 
        id: id
      }
      assert_redirected_to task_display_url
    end
    assert_equal (Task.where("id > 0").count == 0) , true , "タスクが削除されたか?"
  end

end
