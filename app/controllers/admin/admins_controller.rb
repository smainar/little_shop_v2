class Admin::AdminsController < Admin::BaseController
  def show
    @packaged_orders = Order.packaged_orders
    @pending_orders = Order.pending_orders
    @shipped_orders = Order.shipped_orders
    @cancelled_orders = Order.cancelled_orders
  end
end
