module SessionsHelper
  LOGIN_SUCCESS = 'Successfully logged in!'

  # Logs the specified user in and updates the session's user.id and cookies.
  def login(user, remember_me='1')
    session[:user_id] = user.id
    remember_via_cookies(user) if remember_me == '1'
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
    user.forget_remember_digest() if logged_in?
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

  def record_original_request_url
    session[:original_request_url] = request.original_url
  end

  # Redirects after a successful login
  def redirect_after_login
    if (!logged_in?)
      raise
    end
    # If the original request caused a redirect to login, redirect to that initial location.
    if !session[:original_request_url].nil?
      redirect_to(session[:original_request_url], status: 303)
      session.delete(:initial_request)
    else
      # Otherwise, default to the current user's profile page.
      redirect_to(current_user)
    end
    # Always flash success.
    flash[:success] = LOGIN_SUCCESS
  end
end
