require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get root_path
    assert_response :success
    assert_select "title", ApplicationHelper::BASE_TITLE
  end
  test "should get home" do
    get home_path
    assert_response :success
    assert_select "title", ApplicationHelper::BASE_TITLE
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | #{ApplicationHelper::BASE_TITLE}"
  end
  
  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{ApplicationHelper::BASE_TITLE}"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{ApplicationHelper::BASE_TITLE}"
  end

end
