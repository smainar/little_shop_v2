require "rails_helper"
include ActionView::Helpers::TextHelper
# As a merchant
# When I visit my dashboard ("/dashboard")
# If any users have pending orders containing items I sell
# Then I see a list of these orders.
# Each order listed includes the following information:
# - the ID of the order, which is a link to the order show page ("/dashboard/orders/15")
# - the date the order was made
# - the total quantity of my items in the order
# - the total value of my items for that order
RSpec.describe 'As a merchant: ' do
  describe "when I visit my dashboard, " do
    before :each do
      #create 2 pending orders and 1 shipped order.
      @user = create(:user)
      @order_1 = create(:order, user: @user)

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

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      visit merchant_dashboard_path
    end
    it "I see a list of pending orders with only items I sell" do
      expect(page).to have_content("Pending Orders")
# save_and_open_page
      within "#merchant-orders-#{@order_1.id}" do
        expect(page).to have_link("Order #{@order_1.id}")
        expect(page).to have_content("Date Ordered: #{@order_1.created_at}")
        expect(page).to have_content(@item_2.name)
        expect(page).to have_content("Quantity Ordered: #{@oi_2.quantity}")
        expect(page).to have_content("Amount Owed: #{number_to_currency(@oi_2.price_per_item * @oi_2.quantity)}")
      end

      within "#merchant-orders-#{@order_2.id}" do
        expect(page).to have_link("Order #{@order_2.id}")
        expect(page).to have_content("Date Ordered: #{@order_2.created_at}")
        expect(page).to have_content("Number of #{@item_2.name} ordered: #{@oi_3.quantity}")
        expect(page).to have_content("Amount Owed: (#{@oi_3.price_per_item} * #{@oi_3.quantity}")

        expect(page).to have_content("Number of #{@item_3.name} ordered: #{@oi_4.quantity}")
        expect(page).to have_content("Amount Owed: (#{@oi_4.price_per_item} * #{@oi_4.quantity}")
      end

      expect(page).to_not have_content(@order_3.id)
    end
  end
end
