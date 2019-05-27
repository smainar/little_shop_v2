class Admin::UsersController < Admin::BaseController
  def show
  end

  def index
    @users = User.regular_users
  end
end
