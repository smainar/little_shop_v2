class Merchant::MerchantsController < Merchant::BaseController
  def show
    @merchant = current_user
    @merchant_orders = Order.pending_merchant_orders(current_user)
  end
end
