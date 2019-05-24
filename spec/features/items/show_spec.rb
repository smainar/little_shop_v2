require 'rails_helper'

RSpec.describe "As any kind of user, " do
  describe  "I visit the item show page, " do
    before :each do
      @user = create(:user)
      @admin = create(:admin)
      @merchant_1 = create(:merchant)
      @item_1 = create(:item, user: @merchant_1, inventory: 15)

      @order_item_1 = create(:fulfilled_order_item, item: @item_1, created_at: 3.days.ago, updated_at: 1.days.ago)
      @order_item_2 = create(:fulfilled_order_item, item: @item_1, created_at: 2.days.ago, updated_at: 1.days.ago)
      @order_item_3 = create(:fulfilled_order_item, item: @item_1, created_at: 4.days.ago, updated_at: 1.days.ago)
    end

    it "logged in user can see all the information for the item" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit item_path(@item_1)
      expect(current_path).to eq(item_path(@item_1))

      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_1.description)
      expect(page).to have_css("img[src*='#{@item_1.image}']")
      expect(page).to have_content(@merchant_1.name)
      expect(page).to have_content(@item_1.inventory)
      expect(page).to have_content(number_to_currency(@item_1.price))
      expect(page).to have_content(@item_1.average_fulfillment_time)
      expect(page).to have_button("Add to Cart")
    end

    it "admin cannot see Add to Cart link" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit item_path(@item_1)

      expect(page).to_not have_button("Add to Cart")
    end

    it "merchant cannot see Add to Cart link" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_1)
      visit item_path(@item_1)

      expect(page).to_not have_button("Add to Cart")
    end

    it "a visitor can see Add to Cart link" do
      visit item_path(@item_1)

      expect(page).to have_button("Add to Cart")
    end
  end
end
