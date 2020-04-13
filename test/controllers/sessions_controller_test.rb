require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get login_path
    assert_response :success
  end

  # test "should create new session" do
  #   post login_path
  #   assert_response :success
  # end

  # test "should delete session" do
  #   delete logout_path
  #   assert_response :success
  # end

end
