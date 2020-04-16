require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get(signup_path)
    assert_no_difference 'User.count' do
      post(
        users_path,
        params: {
          user: {
            name:  "",
            email: "user@invalid",
            password: "foo",
            password_confirmation: "bar"
          }
        });
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation', 1
    assert_select 'div.field_with_errors', 8
    # TODO: still not validating that the url is /signup before and after
  end

  test "valid signup" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post(
        users_path,
        params: {
          user: {
            name:  "Foo Bar",
            email: "foo@bar.com",
            password: "foobar",
            password_confirmation: "foobar"
          }
        });
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select "div.alert-success", UsersController::SIGNUP_SUCCESS
    assert is_logged_in?
    assert_select "a[href=?]", logout_path
  end
end