class ItemsController < ApplicationController

  def index
    @items = Item.active_items
  end

  def show
    @item = Item.find(params[:id])
    @merchant = @item.user
  end
end
