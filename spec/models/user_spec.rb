require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it {should validate_presence_of :email}
    it {should validate_presence_of :role}
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}

    it {should validate_presence_of :email}
    it {should validate_presence_of :password_digest}
  end

  describe 'relationships' do
    it {should have_many :items}
    it {should have_many :orders}
  end

  describe 'Class Methods' do
    describe '::active_merchants' do
      it 'should return all active merchants' do
        active_merchant_1 = create(:merchant)
        active_merchant_2 = create(:merchant)
        inactive_merchant = create(:inactive_merchant)
        regular_active_user = create(:user)
        active_admin = create(:admin)

        expect(User.active_merchants).to eq([active_merchant_1, active_merchant_2])
      end
    end

    describe '::inactive_merchants' do
      it 'should return all inactive (disabled) merchants' do
        active_merchant = create(:merchant)
        inactive_merchant_1 = create(:inactive_merchant)
        inactive_merchant_2 = create(:inactive_merchant)
        inactive_user = create(:inactive_user)

        expect(User.inactive_merchants).to eq([inactive_merchant_1, inactive_merchant_2])
      end
    end

    describe "statistics" do
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

        @order_8 = create(:order, user: @user_4) # total_quantity = 1
        # merchant_3:
        @oi_10 = create(:fulfilled_order_item, order: @order_8, item: @item_4, quantity: 1, price_per_item: 1.0)

        @order_6 = create(:order, user: @user_4) # total_quantity = 5
        # merchant_4:
        @oi_8 = create(:fulfilled_order_item, order: @order_6, item: @item_6, quantity: 5, price_per_item: 10000.0)
      end

      xit '::top_3_by_revenue shows top 3 merchants who have sold the most by price, and their revenue' do
        top_3_merchants = [@merchant_4, @merchant_1, @merchant_2]
        top_3_revenues = [50000, 60, 31]

        expect(User.top_3_by_revenue).to eq(top_3_merchants)

        actual = User.top_3_by_revenue.map(&:total_revenue)
        expect(actual).to eq(top_3_revenues)
      end

      xit '::top_3_merch_by_quantity shows top 3 merchants who have sold the most by quantity, and their revenue' do
        top_3_merchants = [@merchant_1, @merchant_4, @merchant_2]
        top_3_merchants_revenues = [60, 50000, 31]

        expect(User.top_3_merch_by_quantity).to eq(top_3_merchants)

        actual = User.top_3_merch_by_quantity.map(&:total_revenue)
        expect(actual).to eq(top_3_merchants_revenues)
      end
    end
  end
end
