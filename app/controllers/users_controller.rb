class UsersController < ApplicationController
  before_action :check_logged_in, only: [:index, :edit, :update]
  before_action :check_authorized, only: [:edit, :update]

  SIGNUP_SUCCESS = "Successfully signed up! Welcome!"
  UPDATE_SUCCESS = "Account settings updated!"
  NOT_AUTHORIZED = "You are not authorized to view other users' pages."

  # Action that lists all users
  def index
    @users = User.all
  end

  # Action that shows a user profile
  def show
    @user = User.find(params[:id])
  end

  # Action that generates a new user (i.e. before signup)
  def new
    @user = User.new
  end

  # Action that generates a new user with data (i.e. as a result of signup)
  def create
    @user = User.new(user_params)
    if (@user.save())
      login(@user)
      redirect_to @user
      flash[:success] = SIGNUP_SUCCESS
    else
      render 'new', status: 400
    end
  end

  # Action that allows a user to update their account (before editing)
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if (@user.update_attributes(user_params))
      redirect_to @user
      flash[:success] = UPDATE_SUCCESS
    else
      render 'edit', status: 400
    end
  end

  private def check_logged_in
    if !helpers.logged_in?
      flash[:danger] = "Please log in."
      helpers.record_original_request_url
      redirect_to(login_url)
    end
  end

  private def check_authorized
    # Check if the logged in user (via cookies/session) matches the requested url.
    if (helpers.current_user.id.to_s != params[:id])
      redirect_to(root_path)
      flash[:danger] = 'You are not authorized to view other users\' pages.'
    end
  end

  private def user_params
    return params
      .require(:user)
      .permit(
        :name,
        :email,
        :password,
        :password_confirmation)
  end

end
