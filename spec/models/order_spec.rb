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

  describe "class methods" do
    before(:each) do
      @merchant_1 = create(:merchant)
      @item_1 = create(:item, user: @merchant_1)

      @merchant_2 = create(:merchant)
      @item_2 = create(:item, user: @merchant_2)

      @merchant_3 = create(:merchant)
      @item_4 = create(:item, user: @merchant_3)
      @item_5 = create(:item, user: @merchant_3)

      @merchant_4 = create(:merchant)
      @item_6 = create(:item, user: @merchant_4)

      @merchant_5 = create(:inactive_merchant) # should not be included in stats
      @item_3 = create(:item, user: @merchant_5)

      ####### @user_1
      @user_1 = create(:user)

      @order_1 = create(:shipped_order, user: @user_1) # total_quantity = 101
      # merchant_1:
      @oi_1 = create(:fulfilled_order_item, order: @order_1, item: @item_1, quantity: 100, price_per_item: 0.50)
      # merchant_2:
      @oi_2 = create(:fulfilled_order_item, order: @order_1, item: @item_2, quantity: 1, price_per_item: 30.0)

      ####### @user_2
      @user_2 = create(:user)

      @order_2 = create(:shipped_order, user: @user_2) # total_quantity = 2200
      # merchant_1:
      @oi_7 = create(:fulfilled_order_item, order: @order_2, item: @item_1, quantity: 200, price_per_item: 0.05)
      # merchant_1:
      @oi_3 = create(:fulfilled_order_item, order: @order_2, item: @item_3, quantity: 2000, price_per_item: 100.0)

      ####### @user_3
      @user_3 = create(:user)

      @order_3 = create(:order, user: @user_3) # pending order
      # merchant_3 / pending order -- should not be included in stats for sales:
      @oi_4 = create(:fulfilled_order_item, order: @order_3, item: @item_4, quantity: 300, price_per_item: 20.0)

      @order_4 = create(:cancelled_order, user: @user_3)
      # merchant_3 / cancelled order -- should not be included in stats for sales:
      @oi_5 = create(:fulfilled_order_item, order: @order_4, item: @item_4, quantity: 400, price_per_item: 13.0)

      @order_5 = create(:packaged_order, user: @user_3)
      # merchant_3 / packaged order -- should not be included in stats for sales:
      @oi_6 = create(:fulfilled_order_item, order: @order_5, item: @item_5, quantity: 410, price_per_item: 25.0)

      @order_7 = create(:shipped_order, user: @user_3) # total_quantity = 1
      # merchant_2:
      @oi_9 = create(:fulfilled_order_item, order: @order_7, item: @item_2, quantity: 1, price_per_item: 1.0)

      ####### @user_4
      @user_4 = create(:user)

      @order_8 = create(:shipped_order, user: @user_4) # total_quantity = 1
      # merchant_3:
      @oi_10 = create(:fulfilled_order_item, order: @order_8, item: @item_4, quantity: 1, price_per_item: 1.0)

      @order_6 = create(:shipped_order, user: @user_4) # total_quantity = 5
      # merchant_4:
      @oi_8 = create(:fulfilled_order_item, order: @order_6, item: @item_6, quantity: 5, price_per_item: 10000.0)
    end

    it '::top_3_by_quantity shows top 3 biggest orders by quantity of items shipped in an order, plus their quantities' do
      top_3_orders = [@order_2, @order_1, @order_6]
      top_3_order_quantities = [2200, 101, 5]

      expect(Order.top_3_by_quantity).to eq(top_3_orders)

      actual = Order.top_3_by_quantity.map(&:total_quantity)
      expect(actual).to eq(top_3_order_quantities)
    end
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
end
