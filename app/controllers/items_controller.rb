class ItemsController < ApplicationController

  def index
    @items = Item.active_items
    @most_popular_items = Item.sort_by_popularity(5, :desc)
    @least_popular_items = Item.sort_by_popularity(5, :asc)
  end

  def show
    @item = Item.find(params[:id])
    @merchant = @item.user
  end
end
