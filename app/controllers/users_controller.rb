class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    # uncomment to cause rails server to open a console
    # at this line whenever it executes
    # debugger 
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if (@user.save())
      login(@user)
      redirect_to @user
      flash[:success] = "Successfully signed up! Welcome!"
    else
      render 'new'
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
