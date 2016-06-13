require 'test_helper'

class InstagramControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get feed" do
    get :feed
    assert_response :success
  end

  test "should get tags" do
    get :tags
    assert_response :success
  end

end
