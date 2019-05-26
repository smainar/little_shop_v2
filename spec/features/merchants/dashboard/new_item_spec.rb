require 'rails_helper'

RSpec.describe "Merchant Adds an Item", type: :feature do
  context "as a merchant" do
    before(:each) do
      merchant = create(:merchant)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
    end

    it 'I can get to the new item page from the merchant items index' do
      visit merchant_items_path

      click_link "Add a New Item"

      expect(current_path).to eq(new_merchant_item_path)
    end
  end
end
