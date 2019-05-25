require 'rails_helper'

RSpec.describe Order, type: :model do

  describe 'validates' do
    it {should validate_presence_of :status}
  end

  describe 'relationships' do
    it {should have_many :order_items}
    it {should have_many(:items).through(:order_items)}
    it {should belong_to :user}
  end

  describe "instance methods" do
    before(:each) do
      @user = create(:user)
      @merchant = create(:merchant)
      @order_1 = create(:order, user: @user)
      @item_1 = create(:item, user: @merchant, price: 4.50)
      @item_2 = create(:item, user: @merchant, price: 2.33)
      @oi_1 = create(:order_item, item: @item_1, order: @order_1, quantity: 3, price_per_item: @item_1.price)
      # note: in @oi_2 below, the price_per_item is intentionally different than the item's price, to make sure that the methods are using the price_per_item instead of the price in certain methods
      @oi_2 = create(:order_item, item: @item_2, order: @order_1, quantity: 1, price_per_item: @item_2.price - 0.33)
    end

    it "#grand_total" do
      total_cost = @oi_1.price_per_item * @oi_1.quantity + @oi_2.price_per_item * @oi_2.quantity

      expect(@order_1.grand_total).to eq(total_cost)
    end

    it "#total_quantity" do
      expect(@order_1.total_quantity).to eq(@oi_1.quantity + @oi_2.quantity)
    end
  end
end
