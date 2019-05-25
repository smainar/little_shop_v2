class MerchantsController < ApplicationController
  def index
    @active_merchants = User.active_merchants
  end
end
