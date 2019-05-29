class Merchant::OrderItemsController < Merchant::BaseController
  def fulfill
    oi = OrderItem.find(params[:id])
    order = oi.order_id
    item = oi.item_id
    oi.fulfilled = true
    oi.update_item_inventory
    oi.save
    redirect_to merchant_order_path(order)
    flash[:message] = "Your item was fulfilled."
  end
end
