require 'test_helper'

class UsersEditAccountSettingsTest < ActionDispatch::IntegrationTest
  
  def setup
    @user1 = users(:user1)
    @user2 = users(:user2)
  end

  test "update success same password" do
    login()

    get edit_user_path(@user1)
    assert_no_difference 'User.count' do
      patch(
        user_path(@user1),
        params: {
          user: {
            name: "New name",
            email: "new_email@foobar.com",
            password: "password",
            password_confirmation: "password"
          }
        })
    end

    assert_redirected_to @user1
    follow_redirect!

    assert_template 'users/show'
    updated_user = User.find(@user1.id)
    assert_equal updated_user.name, "New name"
    assert_equal updated_user.email, "new_email@foobar.com"
    assert updated_user.authenticate("password")
    assert_select "div.alert-success", UsersController::UPDATE_SUCCESS
  end

  test "update success empty password" do
    login()

    get edit_user_path(@user1)
    assert_no_difference 'User.count' do
      patch(
        user_path(@user1),
        params: {
          user: {
            name: "New name",
            email: "new_email@foobar.com",
            password: "",
            password_confirmation: ""
          }
        })
    end

    assert_redirected_to @user1
    follow_redirect!

    assert_template 'users/show'
    updated_user = User.find(@user1.id)
    assert_equal updated_user.name, "New name"
    assert_equal updated_user.email, "new_email@foobar.com"
    assert updated_user.authenticate("password1")
    assert_select "div.alert-success", UsersController::UPDATE_SUCCESS
  end

  test "update success new password" do
    login()

    get edit_user_path(@user1)
    assert_no_difference 'User.count' do
      patch(
        user_path(@user1),
        params: {
          user: {
            name: "New name",
            email: "new_email@foobar.com",
            password: "new password",
            password_confirmation: "new password"
          }
        })
    end

    assert_redirected_to @user1
    follow_redirect!

    assert_template 'users/show'
    updated_user = User.find(@user1.id)
    assert_equal updated_user.name, "New name"
    assert_equal updated_user.email, "new_email@foobar.com"
    assert updated_user.authenticate("new password")
    assert_select "div.alert-success", UsersController::UPDATE_SUCCESS
  end

  test "failure invalid" do
    login()

    get edit_user_path(@user1)
    assert_no_difference 'User.count' do
      patch(
        user_path(@user1),
        params: {
          user: {
            name: "New name",
            email: "new_email@invalid email dot com",
            password: "",
            password_confirmation: ""
          }
        })
    end

    assert_template 'users/edit'
    unchanged_user = User.find(@user1.id)
    assert_equal unchanged_user.name, @user1.name
    assert_equal unchanged_user.email, @user1.email
    assert_select "div.alert-danger", 1
    assert_select 'div#error_explanation', 1
    assert_select 'div.field_with_errors', 2
  end

  test "failure not logged in unauthorized" do
    get edit_user_path(@user1)

    assert_response :redirect
    assert_redirected_to login_path

    patch(
      user_path(@user1),
      params: {
        user: {
          name: "New name",
          email: "new_email@foobar.com",
          password: "",
          password_confirmation: ""
        }
      })

    assert_response :redirect
    assert_redirected_to login_path

    unchanged_user = User.find(@user1.id)
    assert_equal unchanged_user.name, @user1.name
    assert_equal unchanged_user.email, @user1.email
  end

  test "failure logged in as different user unauthorized" do
    login(email: @user2.email, password: 'password2')

    get edit_user_path(@user1)

    assert_response :redirect
    assert_redirected_to root_path

    patch(
      user_path(@user1),
      params: {
        user: {
          name: "New name",
          email: "new_email@foobar.com",
          password: "",
          password_confirmation: ""
        }
      })

    assert_response :redirect
    assert_redirected_to root_path

    unchanged_user = User.find(@user1.id)
    assert_equal unchanged_user.name, @user1.name
    assert_equal unchanged_user.email, @user1.email
  end
end
