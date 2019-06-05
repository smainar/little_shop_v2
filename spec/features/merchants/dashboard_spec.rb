require 'rails_helper'

RSpec.describe "Merchant Dashboard" do
  context "merchant sees a to-do list when they visit their dashboard" do
    before :each do
      @merchant = create(:merchant)
      @admin = create(:admin)

      @address = create(:address)

      @item_1 = create(:item, user: @merchant, image: "https://cdn.dribbble.com/users/476251/screenshots/2619255/attachments/523315/placeholder.png")
      @item_2 = create(:item, user: @merchant)

      @order_1 = create(:order, address: @address)
      @order_2 = create(:order, address: @address)

      @order_3 = create(:shipped_order, address: @address)
      @order_4 = create(:cancelled_order, address: @address)

      create(:order_item, order: @order_1, item: @item_1, quantity: 1, price_per_item: 10)
      create(:order_item, order: @order_1, item: @item_2, quantity: 2, price_per_item: 10)
      create(:order_item, order: @order_2, item: @item_2, quantity: 3, price_per_item: 10)
      create(:order_item, order: @order_3, item: @item_2, quantity: 4, price_per_item: 10)
      create(:order_item, order: @order_4, item: @item_1, quantity: 10, price_per_item: 10)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    end

    it "displays list of items using a placeholder image" do
      visit merchant_dashboard_path

      expect(page).to have_content("Needs Attention:")
    end
  end
end
