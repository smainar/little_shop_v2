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
      @item_3 = create(:item, user: @merchant, price: 1.99)
      @oi_1 = create(:order_item, item: @item_1, order: @order_1, quantity: 3, price_per_item: @item_1.price)
      # note: in @oi_2 below, the price_per_item is intentionally different than the item's price, to make sure that the methods are using the price_per_item instead of the price in certain methods
      @oi_2 = create(:order_item, item: @item_2, order: @order_1, quantity: 1, price_per_item: @item_2.price - 0.33)
    end

    it "#grand_total returns the total cost" do
      total_cost = @oi_1.price_per_item * @oi_1.quantity + @oi_2.price_per_item * @oi_2.quantity

      expect(@order_1.grand_total).to eq(total_cost)
    end

    it "#total_quantity returns the total count of all items' quantities" do
      expect(@order_1.total_quantity).to eq(@oi_1.quantity + @oi_2.quantity)
    end

    it "#item_price returns the purchase price for a particular item in the order" do
      expect(@order_1.item_price(@item_2)).to eq(@oi_2.price_per_item)
      expect(@order_1.item_price(@item_2)).to_not eq(@item_2.price)
      expect(@order_1.item_price(@item_3)).to eq(nil)
    end

    it "#item_quantity returns the quantity of a particular item in the order" do
      expect(@order_1.item_quantity(@item_2)).to eq(@oi_2.quantity)
      expect(@order_1.item_quantity(@item_3)).to eq(0)
    end
  end

  describe 'class methods' do
    before :each do
      #create 2 pending orders and 1 shipped order.
      @user_1 = create(:user)
      @order_1 = create(:order, user: @user_1)

      @user_2 = create(:user)
      @order_2 = create(:order, user: @user_2)
      @order_3 = create(:shipped_order, user: @user_2)

      #create an item for another merchant that is part of one of our merchant's orders.
      @other_merchant = create(:merchant)
      @item_1 = create(:item, user: @other_merchant, price: 4.00)

      #items that are sold current merchant.
      @merchant = create(:merchant)
      @item_2 = create(:item, user: @merchant, price: 2.00)
      @item_3 = create(:item, user: @merchant, price: 1.00)

      #order1 with current merchant and other merchant's items.
      @oi_1 = create(:order_item, item: @item_1, order: @order_1, quantity: 2, price_per_item: @item_1.price)
      @oi_2 = create(:order_item, item: @item_2, order: @order_1, quantity: 3, price_per_item: @item_2.price)

      #order 2 with current merchant's items only.
      @oi_3 = create(:order_item, item: @item_2, order: @order_2, quantity: 4, price_per_item: @item_1.price)
      @oi_4 = create(:order_item, item: @item_3, order: @order_2, quantity: 5, price_per_item: @item_2.price - 0.25)

      #order 3 with shipped status for current merchant's item.
      @oi_5 = create(:order_item, item: @item_3, order: @order_3, quantity: 6, price_per_item: @item_2.price)
    end

    it "should return pending orders for a specific merchant's items in the orders" do
      pending_orders = [@order_1, @order_2]
      expect(Order.pending_merchant_orders(@merchant)).to eq(pending_orders)
    end
  end
end
