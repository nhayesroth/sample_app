module SessionsHelper

  # Logs the specified user in and updates the session's user.id
  def login(user)
    session[:user_id] = user.id
  end

  # Exits the current session, logging the user out.
  def logout()
    session.delete(:user_id)
    @current_user = nil
  end

  # Returns whether there is a user already logged in
  def logged_in?
    return !current_user().nil?
  end

  # Gets the currently logged in user (nil if none is logged in)
  def current_user
    if session[:user_id] and !@current_user
      @current_user = User.find_by_id(session[:user_id])
    end
    return @current_user
  end

end
