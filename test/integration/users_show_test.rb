require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @user1 = users(:user1)
    @user2 = users(:user2)
  end

  test "get my profile logged in" do
    login
    get(user_path(@user1))
    assert_select("a[href=?]", edit_user_path(@user1))
  end

  test "get profile not logged in" do
    get(user_path(@user1))
    assert_select("a[href=?]", edit_user_path(@user1), count: 0)
  end

  test "get other profile logged in" do
    login
    get(user_path(@user2))
    assert_select("a[href=?]", edit_user_path(@user2), count: 0)
  end
end
