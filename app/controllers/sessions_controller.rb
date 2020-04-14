class SessionsController < ApplicationController
  def new
  end

  def create
    # Fail fast if either param is empty.
    if params[:session][:email].empty? or params[:session][:password].empty?
      flash.now[:danger] = 'Please enter your email and password.'
      render 'new'
      return
    end
    # Check if the e-mail is associated with an account.
    user = User.find_by_email(params[:session][:email].downcase)
    if !user
      flash.now[:danger] = "#{params[:session][:email].downcase} is not associated with an account."
      render 'new'
      return
    end
    # Authenticate the user and return depending on the result.
    authenticated = user.authenticate(params[:session][:password])
    if authenticated
      helpers.login(user)
      redirect_to(user)
      flash[:success] = 'Successfully logged in!'
      return
    else
      flash.now[:danger] = 'Password is incorrect!'
      render 'new'
      return
    end
  end

  def destroy
    logout(helpers.current_user)
    redirect_to root_url
    flash[:success] = "Successfully logged out!"
  end
end
