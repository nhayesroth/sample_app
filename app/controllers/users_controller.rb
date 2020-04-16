class UsersController < ApplicationController

  SIGNUP_SUCCESS = "Successfully signed up! Welcome!"
  UPDATE_SUCCESS = "Account settings updated!"
  UPDATE_FAILURE = "Failed to update account settings!"

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
      render 'new'
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
      redirect_to edit_user_path(@user)
      flash[:danger] = UPDATE_FAILURE
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
