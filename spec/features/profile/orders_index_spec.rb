require 'rails_helper'

RSpec.describe "User Profile Orders Index", type: :feature do
  context "as a registered user" do
    before(:each) do
      @user = create(:user)
      @other_user = create(:user)
      @merchant = create(:merchant)
      @order_1 = create(:order, user: @user)
      @order_2 = create(:order, user: @user)
      @order_3 = create(:order, user: @other_user)
      @item_1 = create(:item, user: @merchant)
      @item_2 = create(:item, user: @merchant)
      @item_3 = create(:item, user: @merchant)
      @oi_1 = create(:order_item, item: @item_1, order: @order_1, quantity: 3, price_per_item: @item_1.price)
      @oi_2 = create(:order_item, item: @item_3, order: @order_1, quantity: 1, price_per_item: @item_3.price)
      @oi_3 = create(:order_item, item: @item_2, order: @order_2, quantity: 4, price_per_item: @item_2.price)
      @oi_4 = create(:order_item, item: @item_1, order: @order_3, quantity: 10, price_per_item: @item_1.price)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'displays info for all of my orders' do
      visit user_orders_path

      within("#order-#{@order_1.id}") do
        expect(page).to have_link("Order #{@order_1.id}")
        expect(page).to have_content("Placed on: #{@order_1.created_at}")
        expect(page).to have_content("Last Updated: #{@order_1.updated_at}")
        expect(page).to have_content("Status: #{@order_1.status}")
        expect(page).to have_content("Total Cost: #{number_to_currency(@order_1.grand_total)}")
      end

      within("#order-#{@order_2.id}") do
        expect(page).to have_link("Order #{@order_2.id}")
        expect(page).to have_content("Placed on: #{@order_2.created_at}")
        expect(page).to have_content("Last Updated: #{@order_2.updated_at}")
        expect(page).to have_content("Status: #{@order_2.status}")
        expect(page).to have_content("Total Cost: #{number_to_currency(@order_2.grand_total)}")
      end

      expect(page).to_not have_content("Order #{@order_3.id}")
    end
  end
end
