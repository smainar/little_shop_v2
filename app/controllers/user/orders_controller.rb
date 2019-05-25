class User::OrdersController < User::BaseController
  def index
    @user_orders = current_user.orders
  end
end
