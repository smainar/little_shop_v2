class User::UsersController < User::BaseController
  def show
    @user_orders = current_user.orders
    @addresses = current_user.addresses
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.email != params[:user][:email].downcase && User.find_by(email: params[:user][:email].downcase)
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

  def update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, addresses_attributes: [:id, :street, :city, :state, :zip])
  end
end
