require 'test_helper'

class UsersAuthorizationRedirectTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:user1)
    @unauthorized_operations = [
      lambda { get_edit_user_1 },
      lambda { patch_edit_user_1 }]
  end

  private def get_edit_user_1
    get edit_user_path(@user)
  end

  private def patch_edit_user_1
    patch(
      edit_user_path(@user),
      params: {
        user: {
          name: "New name",
          email: "new_email@foobar.com",
          password: "",
          password_confirmation: ""
        }
      })
  end

  test "redirects to initially requested page after login" do
    @unauthorized_operations.each do |unauthorized_operation|
      # Logout to setup the test
      logout

      # Attempt unauthorized operation
      unauthorized_operation.call

      # Verify redirected to login
      assert_response :redirect
      assert_redirected_to login_path

      # Login as user1
      login

      # Verify redirect to users/1/edit
      assert_response :redirect
      assert_redirected_to edit_user_path(@user)
      follow_redirect!
      assert_select 'div.alert-success', SessionsController::LOGIN_SUCCESS

      # Verify neither operation actually modified the user.
      @user.reload
      assert_not_equal(@user.name, "New name")
      assert_not_equal(@user.email, "new_email@foobar.com")
    end
  end

  test "redirects unauthorized user to root" do
    @unauthorized_operations.each do |unauthorized_operation|
      # Logout to setup the test
      logout

      # Attempt unauthorized operation
      unauthorized_operation.call

      # Verify redirected to login
      assert_response :redirect
      assert_redirected_to login_path

      # Login as user2
      login(email: users(:user2).email, password: "password2")

      # Verify redirect to root
      assert_response :redirect
      assert_redirected_to edit_user_path @user
      follow_redirect!
      assert_response :redirect
      assert_redirected_to root_path
      follow_redirect!
      assert_select 'div.alert-danger', UsersController::NOT_AUTHORIZED

      # Verify neither operation actually modified the user.
      @user.reload
      assert_not_equal(@user.name, "New name")
      assert_not_equal(@user.email, "new_email@foobar.com")
    end
  end
end
