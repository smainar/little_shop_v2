require 'rails_helper'

RSpec.describe "Merchant Items Index", type: :feature do
  context "as a merchant" do
    before(:each) do
      @merchant = create(:merchant)
      @item_1 , @item_2 , @item_3 , @item_4 = create_list(:item, 4, user: @merchant)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    end

    it 'I can get to the page from the merchant dashboard' do
      visit merchant_dashboard_path

      click_link "View all items for sale"

      expect(current_path).to eq(merchant_items_path)
    end

    it "has info for all the items I'm selling" do

    end
  end
end
