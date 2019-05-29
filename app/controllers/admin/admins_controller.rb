class Admin::AdminsController < Admin::BaseController
  def show
    @orders = Order.all
  end
end
