require 'test_helper'

class UsersDestroyTestTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:admin)
    @user1 = users(:user1)
    @user2 = users(:user2)
  end

  test "delete my own account should succeed" do
    login
    delete(edit_user_path(@user1))
    assert_redirected_to(root_path)
    follow_redirect!
    assert(User.find_by(email: @user1.email).nil?)
  end
  
  test "delete another account should fail" do
    login
    delete(edit_user_path(@user2))
    assert_redirected_to(root_path)
    follow_redirect!
    assert(!User.find_by(email: @user2.email).nil?)
  end

  test "admin can delete another account" do
    login(email: @admin.email, password: 'password')
    delete(edit_user_path(@user2))
    assert_redirected_to(users_path)
    follow_redirect!
    assert(User.find_by(email: @user2.email).nil?)
  end

end
