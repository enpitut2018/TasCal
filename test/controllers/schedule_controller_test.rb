require 'test_helper'

class ScheduleControllerTest < ActionDispatch::IntegrationTest
  test "should get insert" do
    get schedule_insert_url
    assert_response :success
  end

  test "should get display" do
    get schedule_display_url
    assert_response :success
  end

  test "should get delete" do
    get schedule_delete_url
    assert_response :success
  end

end
