require 'rails_helper'

RSpec.describe "As any kind of user, " do
  describe  "I visit the item show page" do
    before :each do
      @merchant_1 = create(:merchant)
      @item_1 = create(:item, user: @merchant_1, inventory: 15)

      @order_item_1 = create(:fulfilled_order_item, item: @item_1, created_at: 3.days.ago, updated_at: 1.days.ago)
      @order_item_2 = create(:fulfilled_order_item, item: @item_1, created_at: 2.days.ago, updated_at: 1.days.ago)
      @order_item_3 = create(:fulfilled_order_item, item: @item_1, created_at: 4.days.ago, updated_at: 1.days.ago)

      visit item_path(@item_1)
    end

    it "I can see all the information for the item" do
      expect(current_path).to eq(item_path(@item_1))

      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_1.description)
      expect(page).to have_css("img[src*='#{@item_1.image}']")
      expect(page).to have_content(@merchant_1.name)
      expect(page).to have_content(@item_1.inventory)
      expect(page).to have_content(@item_1.price)
      expect(page).to have_content(@item_1.average_fulfillment_time)
    end
  end
end
