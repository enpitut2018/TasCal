# coding: utf-8
require 'test_helper'

class TaskControllerTest < ActionDispatch::IntegrationTest
  def setup
    Task.destroy_all
    
    @task = {
        name: "sample",
        year: "2018",
        month:"07",
        day:"28",
        hour:"12",
        minute:"00"
    }

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

  test "calc_available_time" do
    insert_task "sample", "2018", "07", "28", "12", "00"
    insert_schedule "sample_schedule"

    id = Task.find_by(name: "sample").id

    assert_equal(60*48, TaskController.calc_available_time(id, Time.zone.local(2018, 7, 25, 12, 0)))
  end


  def insert_task name, year, month, day, hour, minute
    post task_insert_url , params:
        {
            name: name,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute
        }
  end

  def insert_schedule(name, s_year="2018", s_month="7", s_day="26", s_hour="12", s_minute="0", e_year="2018", e_month="7", e_day="27", e_hour="12", e_minute="0")
    post schedule_insert_url, params:
        {
            name: name,
            s_year: s_year, s_month: s_month, s_day: s_day, s_hour: s_hour, s_minute: s_minute,
            e_year: e_year, e_month: e_month, e_day: e_day, e_hour: e_hour, e_minute: e_minute
        }
  end

end
