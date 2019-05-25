class UsersController < ApplicationController

  def new
    @user = User.new
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
    if current_user.email != params[:email].downcase && User.find_by(email: params[:email].downcase)
      flash[:error] = "That email address is already in use"
      redirect_to profile_edit_path
      return
    else
      if current_user.update(update_params.to_h)
        flash[:notice] = "Your profile has been updated"
        redirect_to profile_path
      else
        flash[:error] = current_user.errors.full_messages.join(". ")
        redirect_to profile_edit_path
        return
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :address, :city, :state, :zip, :password, :password_confirmation)
  end

  def update_params
    altered_params = params.permit(:name, :email, :address, :city, :state, :zip, :password, :password_confirmation)

    if params[:password] == "" || params[:password_confirmation] == ""
      altered_params = altered_params.except(:password).except(:password_confirmation)
    end

    altered_params
  end
end
