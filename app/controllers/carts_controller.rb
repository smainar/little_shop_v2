class CartsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def create
    item = Item.find(params[:item_id])

    if params[:quantity] == "more"
      if cart.count_of(item.id) + 1 <= item.inventory
        cart.add_item(item.id)
        quantity = cart.count_of(item.id)
        flash[:notice] = "You now have #{pluralize(quantity, item.name)} in your cart."
      else
        flash[:error] = "Merchant does not have any more #{item.name}"
      end
    elsif params[:quantity] == "less"
      cart.remove_item(item.id)
      flash[:notice] = "You now removed 1 #{pluralize(item.name)} in your cart."
    elsif params[:quantity] == "none"
      cart.remove_all_item(item.id)
      flash[:notice] = "You now removed all #{pluralize(item.name)} in your cart."
    else
      render :destroy
    end
    session[:cart] = cart.contents
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
