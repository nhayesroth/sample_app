require 'test_helper'

class UsersEditAccountSettingsTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  test "update success" do
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
    # TODO: change passwords?
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
            email: "new_email@foobar.com",
            password: "",
            password_confirmation: ""
          }
        })
    end

    assert_redirected_to edit_user_path(@user)
    follow_redirect!

    assert_template 'users/edit'
    unchanged_user = User.find(@user.id)
    assert_equal unchanged_user.name, @user.name
    assert_equal unchanged_user.email, @user.email
    assert !flash.empty?
  end
end
