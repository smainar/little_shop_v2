class Merchant::ItemsController < Merchant::BaseController
  def index
    @items = current_user.items
  end

  def new
  end

  def disable
    item = Item.find(params[:id])

    if item.active && item.user == current_user
      item.update(active: false)
      flash[:success] = "#{item.name} is no longer for sale"
    else
      flash[:notice] = "#{item.name} is already disabled"
    end

    redirect_to merchant_items_path
  end
end
