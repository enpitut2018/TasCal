require 'test_helper'
require 'date'

class ScheduleControllerTest < ActionDispatch::IntegrationTest
  def setup
    Schedule.destroy_all
  end

  test "should get insert" do
    get schedule_insert_url
    assert_response :success

    assert_difference 'Schedule.where("id > 0").count' , 1 , "予定の数が増えたか" do
      post schedule_insert_url params: 
      { 
        name: "hoge", 
        s_year: "2018",
        s_month:"07",
        s_day:"25",
        s_hour:"12",
        s_minute:"00",
        e_year: "2018",
        e_month:"07",
        e_day:"29",
        e_hour:"12",
        e_minute:"00"
      }
    end
    # assert_difference 'Schedule.where("id > 0").count' , 1 
    #   object = Schedule.new("hoge", DateTime.new(1993, 2, 24, 11, 30, 45), DateTime.new(1993, 2, 24, 11, 30, 45))
    #   object.save
    # end
  end

  # test "should get display" do
  #   get schedule_display_url
  #   assert_response :success

  #   assert_difference 'Schedule.where("id > 0").count' , -1 , "予定の数が減ったか" do
  #     post params: 
  #     { 
  #       id: "1"
  #     }
  #   end
  # end

  test "should get delete" do
    # get schedule_delete_url
    # assert_response :success

    post schedule_insert_url params: 
      { 
        name: "hoge", 
        s_year: "2018",
        s_month:"07",
        s_day:"25",
        s_hour:"12",
        s_minute:"00",
        e_year: "2018",
        e_month:"07",
        e_day:"29",
        e_hour:"12",
        e_minute:"00"
      }
      # p Schedule.all
    id = Schedule.find_by(name: "hoge").id

    assert_difference 'Schedule.where("id > 0").count' , -1 , "予定が削除できたか" do
      post schedule_delete_url params: 
      {
        id: id
      }

    end

  end

end
