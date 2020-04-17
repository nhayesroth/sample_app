require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user1)
  end

  test "should get new user sign up" do
    get signup_path
    assert_response :success
    assert_select "title", "Sign up | #{ApplicationHelper::BASE_TITLE}"
  end

  test "should get login" do
    get login_path
    assert_response :success
    assert_select "title", "Login | #{ApplicationHelper::BASE_TITLE}"
  end

  test "should get account settings when logged in" do
    login
    get edit_user_path(@user)
    assert_response :success
    assert_select "title", "Account Settings | #{ApplicationHelper::BASE_TITLE}"
  end

end
