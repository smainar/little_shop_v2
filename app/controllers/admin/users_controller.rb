class Admin::UsersController < Admin::BaseController
  def show
    @user = User.find(params[:id])
  end

  def merchant_show
  end

  def index
    @users = User.regular_users
  end
end
