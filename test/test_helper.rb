ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  # Returns true of a test user is logged in
  def is_logged_in?
    return !session[:user_id].nil?
  end

  def login(
      options={
        email: users(:user1).email,
        password: 'password1'
      })
    get login_path
    post(
      login_path,
      params: {
        session: {
          email: options[:email],
          password: options[:password]
        }
      });
    follow_redirect!
    assert is_logged_in?
  end
end
