require 'test_helper'

class UsersAuthorizationRedirectTest < ActionDispatch::IntegrationTest

  class Operation
    attr_accessor(:description, :url, :operation)

    def set_description(description)
      @description = description
    end
    def set_url(url)
      @url = url
    end
    def set_operation(lambda)
      @operation = lambda
      return self
    end
  end

  def setup
    @user = users(:user1)

    @get_edit_user1 = Operation.new()
    @get_edit_user1.set_description("get edit user1")
    @get_edit_user1.set_url(edit_user_path(@user))
    @get_edit_user1.set_operation(lambda { get(@get_edit_user1.url)})

    @patch_user1 = Operation.new()
    @patch_user1.set_description("patch user1")
    @patch_user1.set_url("/users/1/edit")
    @patch_user1.set_operation(
          lambda {
           patch(
              @patch_user1.url,
                params: {
                  user: {
                    name: "New name",
                    email: "new_email@foobar.com",
                    password: "",
                    password_confirmation: ""
                  }
              })})

    @list_users = Operation.new()
    @list_users.set_description("list users")
    @list_users.set_url("/users")
    @list_users.set_operation(lambda { get(@list_users.url) })

    @requests = [
      @get_edit_user1,
      @patch_user1,
      @list_users
    ]
  end

  test "redirects to initially requested page after login" do
    @requests.each do |request|
      puts "DEBUG - testing #{request.description}..."
      # Logout to setup the test
      logout

      # Attempt unauthorized operation
      request.operation.call

      # Verify redirected to login
      assert_response :redirect
      assert_redirected_to login_path

      # Login as user1
      login

      # Verify redirect to initially requested url after login
      assert_response :redirect
      assert_redirected_to request.url
    end
  end

  test "redirects unauthorized user to root" do
    [@get_edit_user1, @patch_user1].each do |request|
      puts "DEBUG - testing #{request.description}..."
      # Logout to setup the test
      logout

      # Attempt unauthorized operation
      request.operation.call

      # Verify redirected to login
      assert_response :redirect
      assert_redirected_to login_path

      # Login as user2
      login(email: users(:user2).email, password: "password2")

      # Verify redirect to root
      assert_response :redirect
      assert_redirected_to request.url
      follow_redirect!
      assert_response :redirect
      assert_redirected_to root_path
      follow_redirect!
      assert_select 'div.alert-danger', UsersController::NOT_AUTHORIZED
    end
  end
end
