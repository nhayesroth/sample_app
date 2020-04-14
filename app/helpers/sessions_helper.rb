module SessionsHelper

  # Logs the specified user in and updates the session's user.id and cookies.
  def login(user)
    session[:user_id] = user.id
    remember_via_cookies(user)
    return @user = current_user()
  end

  # Creates the cookies necessary to keep a user permanently logged in.
  def remember_via_cookies(user)
    remember_token = user.update_remember_digest()
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent.signed[:remember_token] = remember_token
  end

  # Exits the current session, logging the user out.
  def logout(user)
    session.delete(:user_id)
    forget_via_cookies(user)
    @current_user = nil
  end

  # Deletes the cookies necessary to 'forget' a user.
  def forget_via_cookies(user)
    user.forget_remember_digest()
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Returns whether there is a user already logged in.
  def logged_in?()
    return !current_user().nil?
  end

  # Gets the currently logged in user (nil if none is logged in).
  def current_user()
    # Retrieve the user from the current session (if available)
    if session[:user_id]
      return @current_user ||= User.find_by_id(session[:user_id])
    
    # Otherwise, check cookies for a persistent user that never logged out.
    elsif cookies.signed[:user_id]
      user = User.find_by_id(cookies.signed[:user_id]);
      # Verify the cookie against the user's stored digest.
      if user && user.authenticated?(cookies.signed[:remember_token])
        return @current_user = user
      else
        return @current_user = nil
      end
    end
  end
end
