class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user,
                :cart

  before_action :set_default

  private

  def cart
    @cart ||= Cart.new(session[:cart])
  end

  def set_default
    @default_image = Item::DEFAULT_IMAGE
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_admin?
    current_user.admin?
  end

  def current_merchant?
    current_user.merchant?
  end

  def current_user?
    current_user.user?
  end
end
