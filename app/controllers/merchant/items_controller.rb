class Merchant::ItemsController < Merchant::BaseController
  def index
    @items = current_user.items
  end

  def new
  end

  def disable
    item = Item.find(params[:id])

    if item.active && item.user.id == current_user.id
      item.update(active: false)
      flash[:success] = "#{item.name} is no longer for sale"
    else
      flash[:notice] = "#{item.name} is already disabled"
    end

    redirect_to merchant_items_path
  end

  def enable
    item = Item.find(params[:id])

    if !item.active && item.user.id == current_user.id
      item.update(active: true)
      flash[:success] = "#{item.name} is now available for sale"
    else
      flash[:notice] = "#{item.name} is already active"
    end

    redirect_to merchant_items_path
  end

  def fulfill
    item = Item.find(params[:id])

    binding.pry
  end
end
