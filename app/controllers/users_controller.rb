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
      flash[:error] = @user.errors.full_messages.join(". ")
      render :new
    end
  end

  def edit
  end

  def update
    current_user.update_attributes(name: params[:name], address: params[:address], city: params[:city], state: params[:state], zip: params[:zip])

    if User.find_by(email: params[:email].downcase) && current_user.email != params[:email].downcase
      flash[:error] = "That email address is already in use"
      redirect_to profile_edit_path
    else
      current_user.update_attribute(:email, params[:email])
      redirect_to profile_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :address, :city, :state, :zip, :password, :password_confirmation)
  end
end
