class MerchantsController < ApplicationController
  def index
    @active_merchants = User.active_merchants
    @inactive_merchants = User.inactive_merchants
  end
end
