module SessionsHelper

  # Logs the specified user in and updates the session's user.id
  def login(user)
    session[:user_id] = user.id
  end
end
