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
      expect(page).to have_content("#{@active_item.name} is no longer for sale")

      within("#item-#{@active_item.id}") do
        expect(page).to have_button("Enable Item")
        expect(page).to_not have_button("Disable Item")
      end
    end

    # to-do: figure out how to get `go_back` capybara method working to ensure full test coverage
    xit "inactive items can't be re-disabled" do
      visit merchant_items_path

      within("#item-#{@active_item.id}") do
        click_button "Disable Item"
      end

      # Hit the back button in the browser:
      go_back
      # The Disable Item button should be there again (even though the item is disabled in the database)

      within("#item-#{@active_item.id}") do
        click_button "Disable Item"
      end

      expect(current_path).to eq(merchant_items_path)
      expect(page).to have_content("#{@active_item.name} is already disabled")
    end

    xit "other merchant's items can't be disabled" do
      other_merchant_item = create(:item)

      # to-do: figure out how to effectively test (we want to PATCH, not GET), or delete this test
      visit merchant_disable_item_path(other_merchant_item)

      expect(current_path).to eq(merchant_items_path)
      expect(page).to have_content("You don't have permission to disable item #{other_merchant_item.id}")
    end

    it "has a button to enable an inactive item" do
      visit merchant_items_path

      within("#item-#{@inactive_item.id}") do
        click_button "Enable Item"
      end

      expect(current_path).to eq(merchant_items_path)
      expect(page).to have_content("#{@inactive_item.name} is now available for sale")

      within("#item-#{@inactive_item.id}") do
        expect(page).to_not have_button("Enable Item")
        expect(page).to have_button("Disable Item")
      end
    end

    # to-do: figure out how to get `go_back` capybara method working to ensure full test coverage
    xit "active items can't be re-enabled" do
      visit merchant_items_path

      within("#item-#{@inactive_item.id}") do
        click_button "Enable Item"
      end

      # Hit the back button in the browser:
      go_back
      # The Enable Item button should be there again (even though the item is disabled in the database)

      within("#item-#{@inactive_item.id}") do
        click_button "Enable Item"
      end

      expect(current_path).to eq(merchant_items_path)
      expect(page).to have_content("#{@inactive_item.name} is already enabled")
    end

    xit "other merchant's items can't be enabled" do
      other_merchant_item = create(:inactive_item)

      # to-do: figure out how to effectively test (we want to PATCH, not GET), or delete this test
      visit merchant_enable_item_path(other_merchant_item)

      expect(current_path).to eq(merchant_items_path)
      expect(page).to have_content("You don't have permission to enable item #{other_merchant_item.id}")
    end
  end
end




