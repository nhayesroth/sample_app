require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user1 = users(:user1)
    @user2 = users(:user2)
  end

  ################ Basic route tests ################

  test "get first page no params" do
    login
    get(users_path)

    assert_select("a[href=?]", user_path(@user1))
    assert_select("a[href=?]", user_path(@user2))
  end

  test "get first page" do
    login
    get(users_path(page_size: 1))

    # Should have 1 user, a link to the next page, and no link to the prev page.
    assert_select(".users a[href=?]", user_path(@user1))
    assert_select(".users a[href=?]", user_path(@user2), count: 0)
    assert_select("a[href=?]", users_path(page: 2, page_size: 1))
    assert_select("a[href=?]", users_path(page: 0, page_size: 1), count: 0)
  end

  test "get final page" do
    login
    get(users_path(page: 2, page_size: 1))

    # Should have 1 user, no link to the next page, and a link to the prev page.
    assert_select(".users a[href=?]", user_path(@user1), count: 0)
    assert_select(".users a[href=?]", user_path(@user2))
    assert_select("a[href=?]", users_path(page: 3, page_size: 1), count: 0)
    assert_select("a[href=?]", users_path(page: 1, page_size: 1))
  end

  test "page size too big redirects" do
    login

    # Without page param
    get(users_path(page_size: 1000))
    assert_redirected_to(users_path(page_size: UsersController::DEFAULT_PAGE_SIZE))
    follow_redirect!

    # With page param
    get(users_path(page: 1, page_size: 1000))
    assert_redirected_to(users_path(page: 1, page_size: UsersController::DEFAULT_PAGE_SIZE))
    follow_redirect!
  end

  test "page size too small redirects" do
    login

    # Without page param
    get(users_path(page_size: -1))
    assert_redirected_to(users_path(page_size: UsersController::DEFAULT_PAGE_SIZE))
    follow_redirect!

    # With page param
    get(users_path(page: 1, page_size: -1))
    assert_redirected_to(users_path(page: 1, page_size: UsersController::DEFAULT_PAGE_SIZE))
    follow_redirect!
  end

end
