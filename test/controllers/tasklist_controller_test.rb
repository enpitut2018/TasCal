require 'test_helper'

class TasklistControllerTest < ActionDispatch::IntegrationTest
  test "should get insert" do
    get tasklist_insert_url
    assert_response :success
  end

  test "should get delete" do
    get tasklist_delete_url
    assert_response :success
  end

  test "should get display" do
    get tasklist_display_url
    assert_response :success
  end

end
