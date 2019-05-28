class Merchant::OrdersController < Merchant::BaseController
  def show
    @merchant = current_user
    @order = Order.find(params[:id])
  end
end
