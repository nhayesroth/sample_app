require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new user sign up" do
    get signup_path
    assert_response :success
    assert_select "title", "Sign up | #{ApplicationHelper::BASE_TITLE}"
  end

end
