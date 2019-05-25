class User::OrdersController < User::BaseController
  def index
    @user_orders = current_user.orders
  end

  def show
    @order = Order.find(params[:id])
    @items = @order.items
  end
end
