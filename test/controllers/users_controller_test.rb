require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user1 = users(:user1)
    @user2 = users(:user2)
    @admin = users(:admin)
  end

  ################ Basic route tests ################

  test "get new user sign up" do
    get signup_path
    assert_response :success
    assert_select("title", full_title("Sign up"))
  end

  test "get login" do
    get login_path
    assert_response :success
    assert_select("title", full_title("Login"))
  end

  test "get user profile" do
    get(user_path(@user1))
    assert_response(:success)
    assert_select("title", full_title(@user1.name))
  end

  ################ Basic (authenticated) route tests ################

  test "get account settings when logged in" do
    login
    get edit_user_path(@user1)
    assert_response :success
    assert_select("title", full_title("Account Settings"))
  end

  test "get account settings when admin" do
    login(email: @admin.email, password: 'password')
    get edit_user_path(@user1)
    assert_response :success
    assert_select("title", full_title("Account Settings"))
  end

  test "get index when logged in" do
    login
    get(users_path)
    assert_response(:success)
    assert_select("title", full_title("Users"))
  end

  ################ Basic (unauthenticated) route tests ################

  test "get account settings redirects to login when logged out" do
    get edit_user_path(@user1)
    assert_response(:redirect)
    assert_redirected_to(login_path)
  end

  test "get index redirects to login when logged out" do
    get(users_path)
    assert_response(:redirect)
    assert_redirected_to login_path
  end



  test "should not allow the admin attribute to be edited via the web" do
    login(email: @user2.email, password: 'password2')
    assert_not(@user2.admin?)
    patch(
      user_path(@user2),
      params: {
        user: {
          admin: true
        }
      })
    assert_not(@user2.reload.admin?)
  end


end
