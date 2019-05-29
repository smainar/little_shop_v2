class Merchant::ItemsController < Merchant::BaseController
  def index
    @items = current_user.items.where.not(id: nil)
  end

  def new
    @item = current_user.items.new
  end

  def create
    @item = current_user.items.new(item_params)
    if @item.save
      flash[:success] = "#{@item.name} has been added"
      redirect_to merchant_items_path
    else
      flash[:error] = @item.errors.full_messages.join(". ")
      render :new
    end
  end

  def disable
    item = Item.find(params[:id])

    if item.active && item.user.id == current_user.id
      item.update(active: false)
      flash[:success] = "#{item.name} is no longer for sale"
    end

    redirect_to merchant_items_path
  end

  def enable
    item = Item.find(params[:id])

    if !item.active && item.user.id == current_user.id
      item.update(active: true)
      flash[:success] = "#{item.name} is now available for sale"
    end

    redirect_to merchant_items_path
  end

  private

  def item_params
    if params[:item][:image] == ""
      params.require(:item).permit(:name, :description, :price, :inventory)
    else
      params.require(:item).permit(:name, :description, :image, :price, :inventory)
    end
  end
end
