class Merchant::OrderItemsController < Merchant::BaseController
  def fulfill
    oi = OrderItem.find(params[:id])
    oi.update(fulfilled: true)
    oi.update_item_inventory
    order = oi.order

    if order.order_items.all?(&:fulfilled)
      order.update(status: 'packaged')
    end

    redirect_to merchant_order_path(order)
    flash[:message] = "Your item was fulfilled."
  end
end
