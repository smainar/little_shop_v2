class ItemsController < ApplicationController

  def index
    @items = Item.active_items
    @default_image = Item::DEFAULT_IMAGE
  end
end
