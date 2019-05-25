class Merchant::MerchantsController < Merchant::BaseController
  def show
    @merchant = current_user
  end
end
