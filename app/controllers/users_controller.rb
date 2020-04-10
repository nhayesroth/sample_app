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
end
