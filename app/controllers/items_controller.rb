class ItemsController < ApplicationController
  def index
    @items = Item.active_items
  end
end
