class MerchantsController < ApplicationController
  def index
    @active_merchants = User.active_merchants
  end

  def show
  end

  def items_index
  end 
end
