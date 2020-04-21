require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user1 = users(:user1)
    @user2 = users(:user2)
    @admin = users(:admin)
    @users = [@user1, @user2, @admin].sort_by(&:id)
  end

  ################ Basic route tests ################

  test "get first page no params" do
    login
    get(users_path)

    # Should have entries for each user (default page size > 3) and no next/prev link.
    assert_select("a[href=?]", user_path(@user1))
    assert_select("a[href=?]", user_path(@user2))
    assert_select("a[href=?]", user_path(@admin))
    assert_select("a[href=?]", users_path(page: 0), count: 0)
    assert_select("a[href=?]", users_path(page: 2), count: 0)
  end

  test "get each page in order with params" do
    login

    # Page 1
    # Should have the 1st user, a link to the next page, and no link to the prev page.
    get(users_path(page: 1, page_size: 1))
    assert_select(".user-index-entry a[href=?]", user_path(@users[0]))
    assert_select(".next_page a[href=?]", users_path(page: 2, page_size: 1))
    assert_select(".previous_page a[href=?]", '#')

    # Page 2
    # Should have the 2nd user, a link to the next page, and a link to the prev page.
    get(users_path(page: 2, page_size: 1))
    assert_select(".user-index-entry a[href=?]", user_path(@users[1]))
    assert_select(".next_page a[href=?]", users_path(page: 3, page_size: 1))
    assert_select(".previous_page a[href=?]", users_path(page: 1, page_size: 1))

    # Page 3
    # Should have the 3rd user, no link to the next page, and a link to the prev page.
    get(users_path(page: 3, page_size: 1))
    assert_select(".user-index-entry a[href=?]", user_path(@users[2]))
    assert_select(".next_page a[href=?]", '#')
    assert_select(".previous_page a[href=?]", users_path(page: 2, page_size: 1))

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
