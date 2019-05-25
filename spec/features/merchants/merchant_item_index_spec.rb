require 'rails_helper'

RSpec.describe "Merchant Items Index", type: :feature do
  context "as a merchant" do
    it 'should display all of a merchants items' do
      merchant = create(:merchant)
      item_1 , item_2 , item_3 , item_4 = create_list(:item, 4, user:merchant)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit merchant_dashboard_path

      click_link "View all items for sale"

      expect(current_path).to eq(merchant_items_path)
    end
  end
end
