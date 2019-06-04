class User::AddressesController < User::BaseController
  def new
    @user = current_user
    @address = Address.new
  end

  def create
    address = Address.new(address_params)
    address.user_id = params[:format]
    if address.save
      flash[:notice] = "The address for #{address.street} has been saved."
      redirect_to profile_path
    else
      flash[:error] = address.errors.full_messages.join(". ")
      render :new
    end
  end

  private

  def address_params
    params.require(:address).permit(:nickname, :street, :city, :state, :zip)
  end
end
