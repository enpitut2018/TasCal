require 'test_helper'

class TasklistControllerTest < ActionDispatch::IntegrationTest
  # host! "localhost:3000"
  test "should get insert" do
    get tasklist_insert_url
    puts tasklist_insert_url
    assert_response :success

    # test "invalid signup information" do
    #   get 'tasklist/insert'
      # assert_no_difference 'Tasklist.task_count' do
      #   post 'tasklist/insert', params: 
      #   { 
      #     name: "hoge", 
      #     date: "fuga"
      #   }
      #  end
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

  test "should get display" do
    get tasklist_display_url
    assert_response :success
  end

end
