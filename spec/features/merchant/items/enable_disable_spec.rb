require 'rails_helper'

RSpec.describe "Enabling/Disabling Items" do
  describe  "as a merchant" do
    before :each do
      @merchant = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      @active_item = create(:item, user: @merchant)
      @inactive_item = create(:inactive_item, user: @merchant)
    end

    it "has a button to disable an active item" do
      visit merchant_items_path

      within("#item-#{@active_item.id}") do
        click_button "Disable Item"
      end

      expect(current_path).to eq(merchant_items_path)
      expect(page).to have_content("#{@active_item} is no longer for sale")

      within("#item-#{@active_item.id}") do
        expect(page).to have_button("Enable Item")
        expect(page).to_not have_button("Disable Item")
      end
    end

    xit "inactive items can't be re-disabled" do
      visit merchant_disable_item_path(@inactive_item)

      expect(current_path).to eq(merchant_items_path)
      expect(page).to have_content("#{@inactive_item} is already disabled")
    end

    xit "has a button to enable an inactive item" do
      visit merchant_items_path

      within("#item-#{@inactive_item.id}") do
        click_button "Enable Item"
      end

      expect(current_path).to eq(merchant_items_path)
      expect(page).to have_content("#{@inactive_item} is now available for sale")

      within("#item-#{@inactive_item.id}") do
        expect(page).to_not have_button("Enable Item")
        expect(page).to have_button("Disable Item")
      end
    end

    xit "active items can't be re-enabled" do
      visit merchant_enable_item_path(@active_item)

      expect(current_path).to eq(merchant_items_path)
      expect(page).to have_content("#{@active_item} is already active")
    end
  end
end
