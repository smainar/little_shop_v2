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

  describe 'class methods' do
    describe '.active_merhants' do
      it 'should return all active merchants' do
        active_merchant_1 = create(:merchant)
        active_merchant_2 = create(:merchant)
        inactive_merchant = create(:inactive_merchant)
        regular_active_user = create(:user)

        expect(User.active_merchants).to eq([active_merchant_1, active_merchant_2])
      end
    end
  end

  describe 'instance methods' do
    before :each do
      @user_1 = create(:user)
      @user_2 = create(:user)
      @user_3 = create(:user)

      @merchant_1 = create(:merchant)
      @item_1 = create(:item, user: @merchant_1, inventory: 20)
      @item_2 = create(:item, user: @merchant_1, inventory: 20)
      @item_3 = create(:item, user: @merchant_1, inventory: 20)
      @item_4 = create(:item, user: @merchant_1, inventory: 20)
      @item_5 = create(:item, user: @merchant_1, inventory: 20)
      @item_6 = create(:item, user: @merchant_1, inventory: 20)
      @item_7 = create(:inactive_item, user: @merchant_1)

      @merchant_2 = create(:merchant)
      @item_8 = create(:item, user: @merchant_2)

      #shipped orders
      @order_1 = create(:shipped_order, user: @user_1)
      @order_2 = create(:shipped_order, user: @user_2)
      @order_3 = create(:shipped_order, user: @user_3)
      @order_4 = create(:shipped_order, user: @user_1)
      @order_5 = create(:shipped_order, user: @user_2)

      #pending order
      @order_6 = create(:order, user: @user_3)

      #cancelled order
      @order_7 = create(:cancelled_order, user: @user_1)

      #packaged order
      @order_8 = create(:packaged_order, user: @user_2)

      #shipped orders
      @order_item_1 = create(:fulfilled_order_item, item: @item_1, quantity: 2, order: @order_1)
      @order_item_2 = create(:fulfilled_order_item, item: @item_2, quantity: 7, order: @order_2)
      @order_item_3 = create(:fulfilled_order_item, item: @item_5, quantity: 10, order: @order_3)
      @order_item_4 = create(:fulfilled_order_item, item: @item_4, quantity: 5, order: @order_4)
      @order_item_5 = create(:fulfilled_order_item, item: @item_3, quantity: 4, order: @order_4)
      @order_item_6 = create(:fulfilled_order_item, item: @item_3, quantity: 2, order: @order_5)

      @order_item_13 = create(:fulfilled_order_item, item: @item_2, quantity: 5, order: @order_1)
      @order_item_14 = create(:fulfilled_order_item, item: @item_6, quantity: 3, order: @order_1)
      @order_item_15 = create(:fulfilled_order_item, item: @item_8, quantity: 18, order: @order_1)

      #not shipped orders
      @order_item_7 = create(:order_item, item: @item_1, order: @order_6)
      @order_item_8 = create(:order_item, item: @item_1, order: @order_7)
      @order_item_9 = create(:order_item, item: @item_1, order: @order_8)

      @order_item_10 = create(:fulfilled_order_item, item: @item_2, order: @order_6)
      @order_item_11 = create(:fulfilled_order_item, item: @item_2, order: @order_7)
      @order_item_12 = create(:fulfilled_order_item, item: @item_2, order: @order_8)

      #include previously active item that were shipped. Item is now inactive.
    end

    it "can find top five items by quantity" do
      top_five = [@item_2, @item_5, @item_3, @item_4, @item_6]
      expect(@merchant_1.top_five_items).to eq(top_five)
    end
  end
end
