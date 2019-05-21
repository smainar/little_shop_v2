class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:welcome] = "Welcome, #{@user.name}"
      redirect_to '/profile'
    else
      flash[:error] = "Failed to create account"
      redirect_to '/register'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :address, :city, :state, :zip, :password, :password_confirmation)
  end
end
