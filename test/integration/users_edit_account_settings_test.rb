require 'test_helper'

class UsersEditAccountSettingsTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  test "update success same password" do
    login()

    get edit_user_path(@user)
    assert_no_difference 'User.count' do
      patch(
        user_path(@user),
        params: {
          user: {
            name: "New name",
            email: "new_email@foobar.com",
            password: "password",
            password_confirmation: "password"
          }
        })
    end

    assert_redirected_to @user
    follow_redirect!

    assert_template 'users/show'
    updated_user = User.find(@user.id)
    assert_equal updated_user.name, "New name"
    assert_equal updated_user.email, "new_email@foobar.com"
    assert updated_user.authenticate("password")
    assert_select "div.alert-success", UsersController::UPDATE_SUCCESS
  end

  test "update success empty password" do
    login()

    get edit_user_path(@user)
    assert_no_difference 'User.count' do
      patch(
        user_path(@user),
        params: {
          user: {
            name: "New name",
            email: "new_email@foobar.com",
            password: "",
            password_confirmation: ""
          }
        })
    end

    assert_redirected_to @user
    follow_redirect!

    assert_template 'users/show'
    updated_user = User.find(@user.id)
    assert_equal updated_user.name, "New name"
    assert_equal updated_user.email, "new_email@foobar.com"
    assert updated_user.authenticate("password")
    assert_select "div.alert-success", UsersController::UPDATE_SUCCESS
  end

  test "update success new password" do
    login()

    get edit_user_path(@user)
    assert_no_difference 'User.count' do
      patch(
        user_path(@user),
        params: {
          user: {
            name: "New name",
            email: "new_email@foobar.com",
            password: "new password",
            password_confirmation: "new password"
          }
        })
    end

    assert_redirected_to @user
    follow_redirect!

    assert_template 'users/show'
    updated_user = User.find(@user.id)
    assert_equal updated_user.name, "New name"
    assert_equal updated_user.email, "new_email@foobar.com"
    assert updated_user.authenticate("new password")
    assert_select "div.alert-success", UsersController::UPDATE_SUCCESS
  end

  test "failure" do
    login()

    get edit_user_path(@user)
    assert_no_difference 'User.count' do
      patch(
        user_path(@user),
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
    unchanged_user = User.find(@user.id)
    assert_equal unchanged_user.name, @user.name
    assert_equal unchanged_user.email, @user.email
    assert_select "div.alert-danger", 1
    assert_select 'div#error_explanation', 1
    assert_select 'div.field_with_errors', 2
  end
end
