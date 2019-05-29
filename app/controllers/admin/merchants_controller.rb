class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = User.find(params[:id])
    @pending_orders = Order.pending_merchant_orders(@merchant)
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

  def enable
    merchant = User.find(params[:id])
    merchant.update(active: true)
    merchant.save
    flash[:notice] = "#{merchant.name}'s account is now enabled.'"
    redirect_to admin_merchants_path
  end

  def downgrade
  end
end
