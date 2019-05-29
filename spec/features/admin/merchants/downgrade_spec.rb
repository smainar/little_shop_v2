require 'rails_helper'

RSpec.describe "Downgrading a merchant", type: :feature do
  before(:each) do
    @merchant = create(:merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
  end

  context "as a merchant" do
    it "I don't see a button to downgrade my account" do
      visit merchant_dashboard_path

      expect(page).to_not have_content("Downgrade")
    end
  end

  context "as an admin" do
    before(:each) do
      @admin = create(:admin)
      @merchant = create(:merchant)
      @item = create(:item, user: @merchant, name: "RANDOM WORD")
    end

    it "I can downgrade a merchant to a regular user" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      visit admin_merchant_path(@merchant)

      expect(current_path).to eq("/admin/merchants/#{@merchant.id}")

      click_button "Downgrade Account"

      expect(current_path).to eq("/admin/users/#{@merchant.id}")
      expect(page).to have_content("#{@merchant.name} has been downgraded to a regular user")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant.reload)

      visit items_path

      expect(page).to have_content("My Cart")
      expect(page).to_not have_content("Dashboard")

      # All items for sale by @merchant are disabled
      expect(page).to_not have_content(@item.name)
      expect(@item.reload.active).to eq(false)
    end
  end
end
