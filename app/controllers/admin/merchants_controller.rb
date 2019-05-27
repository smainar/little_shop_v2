class Admin::MerchantsController < Admin::BaseController
  def show
  end

  def index
    @merchants = User.all_merchants
  end

  def disable
    merchant = User.find(params[:id])
    merchant.update(active: false)
    merchant.save
    flash[:notice] = "#{merchant.name}'s account is now disabled."
    redirect_to admin_merchants_path
  end
end
