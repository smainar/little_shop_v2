class UsersController < ApplicationController

  def new
    @user = User.new
    @address = @user.addresses.build
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:welcome] = "Welcome, #{@user.name}"
      redirect_to '/profile'
    else
      flash[:error] = @user.errors.full_messages.join(". ")
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, addresses_attributes: [:id, :street, :city, :state, :zip])
  end
end
