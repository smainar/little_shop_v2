class MerchantsController < ApplicationController
  def index
    @active_merchants = User.active_merchants
    @inactive_merchants = User.inactive_merchants
    @top_3_orders_by_quantity = Order.top_3_by_quantity
    @top_3_merchants_by_revenue = User.top_3_by_revenue
  end
end
