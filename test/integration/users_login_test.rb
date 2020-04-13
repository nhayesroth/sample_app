require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  @@user = User.create(
      name: "foobar",
      email: "user@gmail.com",
      password: "foobar",
      password_confirmation: "foobar")

  test "test empty params" do
    params1 = {session: {email: "", password: ""}}
    params2 = {session: {email: "", password: "foobar"}}
    params3 = {session: {email: "user@gmail.com", password: ""}}

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

  test "test email not associated with account" do
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

  test "test invalid password" do
    params = {session: {email: "user@gmail.com", password: "wrong password"}}

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

  test "test success" do
    params = {session: {email: @@user.email, password: @@user.password}}

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
