class User::AddressesController < User::BaseController
  def new
    @user = current_user
    @address = Address.new
  end

  def create
    address = Address.new(address_params)
    address.user_id = params[:format]
    if address.save
      flash[:notice] = "Your address at #{address.street} was saved."
      redirect_to profile_path
    else
      flash[:error] = address.errors.full_messages.join(". ")
      render :new
    end
  end

  def destroy
    address = Address.find(params[:id])
    address.user_id == current_user.id
    address.destroy
    flash[:notice] = "Your address was deleted."
    redirect_to profile_path
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    address = Address.find(params[:id])
    if address.update_attributes(address_params)
      redirect_to profile_path
    else
      render :edit
    end
  end

  private

  def address_params
    params.require(:address).permit(:nickname, :street, :city, :state, :zip)
  end
end
