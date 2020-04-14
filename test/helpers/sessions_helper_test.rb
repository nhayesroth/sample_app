require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  
  def setup
    @user = users(:michael)
  end

  test "current user returns nil when not logged in" do
    assert_nil current_user
  end

  test "current user returns user when logged in without cookies" do
    login(@user, remember_me="1")
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    assert_equal(@user, current_user())
  end

  test "current user returns user when logged in and remembered" do
    login(@user, remember_me="1")
    assert_equal(@user, current_user())
  end

  test "current user returns user when logged in but not remembered" do
    login(@user, remember_me="0")
    assert_equal(@user, current_user())
  end

  test "current user returns nil when logged in but token is wrong" do
    login(@user, remember_me="1")
    session.delete(:user_id)
    @user.update_attribute(:remember_digest, User.digest(User.new_token()))
    assert_nil current_user
  end

  test "current user returns nil when logged in digest is empty" do
    login(@user, remember_me="1")
    session.delete(:user_id)
    @user.update_attribute(:remember_digest, nil)
    assert_nil current_user
  end
end