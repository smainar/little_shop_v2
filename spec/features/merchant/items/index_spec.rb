require 'rails_helper'

RSpec.describe "Merchant Items Index", type: :feature do
  context "as a merchant" do
    before(:each) do
      @merchant = create(:merchant)

      @other_merchant_item = create(:item)

      @active_never_ordered_item = create(:item, user: @merchant, name: "chairs")
      @disabled_never_ordered_item = create(:inactive_item, user: @merchant)
      @active_ordered_item = create(:item, user: @merchant)
      @disabled_ordered_item = create(:inactive_item, user: @merchant)

      @order = create(:order)
      @oi_1 = create(:order_item, order: @order, item: @active_ordered_item)
      @oi_2 = create(:order_item, order: @order, item: @disabled_ordered_item)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    end

    it 'I can get to the page from the merchant dashboard' do
      visit merchant_dashboard_path

      click_link "View all items for sale"

      expect(current_path).to eq(merchant_items_path)
    end

    it "has info for all the items I'm selling" do
      visit merchant_items_path

      expect(page).to have_link("Add a New Item")
      expect(page).to_not have_content(@other_merchant_item.id)

      within("#item-#{@active_never_ordered_item.id}") do
        expect(page).to have_link(@active_never_ordered_item.name)
        expect(page).to have_content("ID: #{@active_never_ordered_item.id}")
        expect(page).to have_css("img[src*='#{@active_never_ordered_item.image}']")
        expect(page).to have_content(number_to_currency(@active_never_ordered_item.price))
        expect(page).to have_content("#{@active_never_ordered_item.inventory} in stock")
        expect(page).to have_button("Edit Item")
        expect(page).to_not have_button("Enable Item")
        expect(page).to have_button("Disable Item")
        expect(page).to have_button("Delete Item")
      end

      within("#item-#{@disabled_never_ordered_item.id}") do
        expect(page).to have_link(@disabled_never_ordered_item.name)
        expect(page).to have_content("ID: #{@disabled_never_ordered_item.id}")
        expect(page).to have_css("img[src*='#{@disabled_never_ordered_item.image}']")
        expect(page).to have_content(number_to_currency(@disabled_never_ordered_item.price))
        expect(page).to have_content("#{@disabled_never_ordered_item.inventory} in stock")
        expect(page).to have_button("Edit Item")
        expect(page).to have_button("Enable Item")
        expect(page).to_not have_button("Disable Item")
        expect(page).to have_button("Delete Item")
      end

      within("#item-#{@active_ordered_item.id}") do
        expect(page).to have_link(@active_ordered_item.name)
        expect(page).to have_content("ID: #{@active_ordered_item.id}")
        expect(page).to have_css("img[src*='#{@active_ordered_item.image}']")
        expect(page).to have_content(number_to_currency(@active_ordered_item.price))
        expect(page).to have_content("#{@active_ordered_item.inventory} in stock")
        expect(page).to have_button("Edit Item")
        expect(page).to_not have_button("Enable Item")
        expect(page).to have_button("Disable Item")
        expect(page).to_not have_button("Delete Item")
      end

      within("#item-#{@disabled_ordered_item.id}") do
        expect(page).to have_link(@disabled_ordered_item.name)
        expect(page).to have_content("ID: #{@disabled_ordered_item.id}")
        expect(page).to have_css("img[src*='#{@disabled_ordered_item.image}']")
        expect(page).to have_content(number_to_currency(@disabled_ordered_item.price))
        expect(page).to have_content("#{@disabled_ordered_item.inventory} in stock")
        expect(page).to have_button("Edit Item")
        expect(page).to have_button("Enable Item")
        expect(page).to_not have_button("Disable Item")
        expect(page).to_not have_button("Delete Item")
      end
    end

    it "can delete item on item index page" do
      visit merchant_items_path
      name = @active_never_ordered_item.name

      within("#item-#{@active_never_ordered_item.id}") do
        click_on "Delete Item"
      end

      expect(page).to have_content("You have deleted #{name}.")

      within ".merchant-items" do 
        expect(page).to_not have_content(name)
      end
    end
  end
end
