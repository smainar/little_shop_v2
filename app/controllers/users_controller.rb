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
    # to-do: use update_attributes to combine all these
    current_user.update_attribute(:name, params[:name])
    current_user.update_attribute(:address, params[:address])
    current_user.update_attribute(:city, params[:city])
    current_user.update_attribute(:state, params[:state])
    current_user.update_attribute(:zip, params[:zip])

    if User.find_by(email: params[:email].downcase) && current_user.email != params[:email].downcase
      flash[:error] = "Email already taken"
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

  def show
  end
end
