require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "empty params" do
    params1 = {session: {email: "", password: ""}}
    params2 = {session: {email: "", password: "foobar"}}
    params3 = {session: {email: @user.email, password: ""}}

    for params in [params1, params2, params3]
      get login_path
      assert_template 'sessions/new' 
      post(
        login_path,
        params: params);
      assert_template 'sessions/new'
      assert_not flash.empty?
      get root_path
      assert flash.empty?
    end
  end

  test "email not associated with account" do
    params = {session: {email: "unused+email@gmail.com", password: "foobar"}}

    get login_path
    assert_template 'sessions/new' 
    post(
      login_path,
      params: params);
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "invalid password" do
    params = {session: {email: @user.email, password: "wrong password"}}

    get login_path
    assert_template 'sessions/new' 
    post(
      login_path,
      params: params);
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "successful login" do
    params = {session: {email: @user.email, password: 'password'}}

    get login_path
    assert_template 'sessions/new' 
    post(
      login_path,
      params: params);
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test "successful login with remembering" do
    params = {session: {email: @user.email, password: 'password', remember_me: '1'}}

    get login_path
    post(
      login_path,
      params: params);

    assert is_logged_in?
    assert_not_empty cookies[:user_id]
    assert_not_empty cookies[:remember_token]
  end

  test "successful login without remembering" do
    params = {session: {email: @user.email, password: 'password', remember_me: '0'}}

    get login_path
    assert_template 'sessions/new' 
    post(
      login_path,
      params: params);

    assert is_logged_in?
    assert_nil cookies[:user_id]
    assert_nil cookies[:remember_token]
  end

  test "successful logout" do
    # First, login as the test user.
    params = {session: {email: @user.email, password: 'password'}}
    post(
      login_path,
      params: params);
    follow_redirect!
    
    # Logout and verify.
    delete(logout_path)
    assert_redirected_to root_path
    follow_redirect!

    assert !is_logged_in?
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0
    
    # Logout and verify again (e.g. if you had 2 browser windows open).
    delete(logout_path)
    assert_redirected_to root_path
    follow_redirect!

    assert !is_logged_in?
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0
  end
end
