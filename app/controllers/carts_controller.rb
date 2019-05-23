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
    reset_session
    flash[:message] = "Your cart is now empty, anti-capitalist!"
    redirect_to cart_path
  end
end
