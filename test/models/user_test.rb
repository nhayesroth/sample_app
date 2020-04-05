require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
  end

  test "should be valid" do
    user = User.new(name: "Example User", email: "user@foo.com")
    assert user.valid?
  end

  # Field presence validation

  test "name should be present" do
    user = User.new(name: "   ", email: "user@foo.com")
    assert_not user.valid?
  end

  test "email should be present" do
    user = User.new(name: "Foo", email: "   \t")
    assert_not user.valid?
  end

  # Field length validation

 test "name should be short enough" do
    user = User.new(name: "f" * 100, email: "user@foo.com")
    assert_not user.valid?
  end

  test "email should be short enough" do
    user = User.new(name: "Foo", email: "f" * 100 + "@foo.com")
    assert_not user.valid?
  end

  # Email format validation

  test "valid emails should pass" do
    assert User.new(name: "foo", email: "foo@bar.com").valid?
    assert User.new(name: "foo", email: "FOO@bar.com").valid?
    assert User.new(name: "foo", email: "FOO+bar@bar.com").valid?
    assert User.new(name: "foo", email: "FOO+bar+z@bar.com").valid?
    assert User.new(name: "foo", email: "f-o_o.123@bar.com").valid?
    assert User.new(name: "foo", email: "f-o_o.123@BAR.com").valid?
    assert User.new(name: "foo", email: "f-o_o.123@BAR.foo.gz.cn").valid?
  end

  test "invalid emails should be rejected" do
    assert_not User.new(name: "foo", email: "foo@bar....com").valid?
    assert_not User.new(name: "foo", email: " foo@bar.com").valid?
    assert_not User.new(name: "foo", email: "foo @ bar.com").valid?
    assert_not User.new(name: "foo", email: "foo@bar.c om").valid?
    assert_not User.new(name: "foo", email: "foo.at.bar.com").valid?
    assert_not User.new(name: "foo", email: "foo@bar@zoom.com").valid?
    assert_not User.new(name: "foo", email: "foo@bar+z.com").valid?
  end

  test "emails must be unique" do
    # Create and save a user with a given email
    user1 = User.create(name: "foo", email: "foo@bar.com")
    assert user1.valid?

    # Attempting to create another user with the same email should fail (case insensitive)
    user2 = User.new(name: "foo", email: "FoO@bAR.COM")
    assert user1.valid?
    assert_not user2.valid?

    # Destroying the original user allows the new user to pass validation
    user1.destroy
    assert user2.valid?
  end

  test "emails are downcased on save" do
    user = User.create(name: "foo", email: "FoO@bAR.COM")
    assert_equal(user.email, "foo@bar.com")
  end
end
