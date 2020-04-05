require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal(full_title(""), ApplicationHelper::BASE_TITLE)
    assert_equal(
      full_title("foobar"),
      "foobar | #{ApplicationHelper::BASE_TITLE}")
  end
end