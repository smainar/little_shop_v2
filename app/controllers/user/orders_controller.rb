class User::OrdersController < User::BaseController
  def index
    @user_orders = current_user.orders
  end

  def show
    @order = Order.find(params[:id])
    @items = @order.items
  end

  def cancel
    order = Order.find(params[:id])
    order.order_items.update_all(fulfilled: false)
    order.update(status: "cancelled")
    flash[:notice] = "Order #{order.id} has been cancelled"
    redirect_to profile_path
  end
end
