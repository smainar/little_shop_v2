class Admin::AdminsController < Admin::BaseController
  def show
    @packaged_orders = Order.packaged?
  end

  def ship_order
    order = Order.find(params[:format])
    order.update(status: 'shipped')
    flash[:notice] = "#{order.id} has been shipped!"
    redirect_to admin_dashboard_path
  end
end
