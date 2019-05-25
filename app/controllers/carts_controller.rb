class CartsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def create
    item = Item.find(params[:item_id])
    cart.add_item(item.id)
    session[:cart] = cart.contents
    quantity = cart.count_of(item.id)

    flash[:notice] = "You now have #{pluralize(quantity, item.name)} in your cart."
    redirect_to items_path
  end

  def show
  end

  def destroy
    session.delete(:cart)
    flash[:message] = "Your cart is now empty, anti-capitalist!"
    redirect_to cart_path
  end

  def checkout
    new_order = current_user.orders.create
    cart.item_and_quantity_hash.each do |item, quantity|
      OrderItem.create(item: item, order: new_order, quantity: quantity, price_per_item: item.price)
    end
    session.delete(:cart)
    flash[:message] = "Your order was created!"
    redirect_to user_orders_path
  end
end
