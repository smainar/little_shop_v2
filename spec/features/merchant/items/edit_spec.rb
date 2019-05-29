# When I submit the form
# I am taken back to my items page
# I see the item's new information on the page, and it maintains its previous enabled/disabled state
# If I left the image field blank, I see a placeholder image for the thumbnail

require 'rails_helper'

RSpec.describe "Merchant Edits an Item", type: :feature do
  context "as a merchant" do
    before(:each) do
      @merchant = create(:merchant)
      @item = create(:item, user: @merchant)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    end

    it 'I can get to the edit item page from the merchant items index' do
      visit merchant_items_path

      within("#item-#{@item.id}") do
        click_button "Edit Item"
      end

      expect(current_path).to eq(edit_merchant_item_path(@item))
    end

    it "I cannot see the form to edit another merchant's item" do
      other_merchant = create(:merchant)
      other_item = create(:item, user: other_merchant)

      visit edit_merchant_item_path(other_item)

      expect(status_code).to eq(404)
    end

    it "I cannot edit another merchant's item" do
      visit merchant_items_path

      within("#item-#{@item.id}") do
        click_button "Edit Item"
      end

      other_merchant = create(:merchant)

      @item.update(user: other_merchant)

      click_on "Update Item"

      expect(status_code).to eq(404)
    end

    it "I can edit an item's name by filling out a form" do
      visit edit_merchant_item_path(@item)

      expect(current_path).to eq("/dashboard/items/#{@item.id}/edit")

      new_name = "Big Couch"

      fill_in "item[name]", with: new_name

      click_on "Update Item"

      expect(current_path).to eq(merchant_items_path)

      expect(page).to have_content("#{new_name} has been updated")
      expect(@item.reload.name).to eq(new_name)

      within("#item-#{@item.id}") do
        expect(page).to have_link(new_name)
        expect(page).to have_content("ID: #{@item.id}")
        expect(page).to have_css("img[src*='#{@item.image}']")
        expect(page).to have_content(number_to_currency(@item.price))
        expect(page).to have_content("#{@item.inventory} in stock")
      end
    end

    it "I can edit an item's description by filling out a form" do
      visit edit_merchant_item_path(@item)

      expect(current_path).to eq("/dashboard/items/#{@item.id}/edit")

      new_description = "It's a very large couch"

      fill_in "item[description]", with: new_description

      click_on "Update Item"

      expect(current_path).to eq(merchant_items_path)

      expect(page).to have_content("#{@item.reload.name} has been updated")
      expect(@item.reload.description).to eq(new_description)
    end

    it "I can edit an item's image by filling out a form" do
      visit edit_merchant_item_path(@item)

      expect(current_path).to eq("/dashboard/items/#{@item.id}/edit")

      new_image = "https://slimages.macysassets.com/is/image/MCY/products/0/optimized/8235120_fpx.tif?op_sharpen=1&wid=500&hei=613&fit=fit,1&$filtersm$"

      fill_in "item[image]", with: new_image

      click_on "Update Item"

      expect(current_path).to eq(merchant_items_path)

      expect(page).to have_content("#{@item.reload.name} has been updated")
      expect(@item.reload.image).to eq(new_image)

      within("#item-#{@item.id}") do
        expect(page).to have_css("img[src*='#{new_image}']")
      end
    end

    it "I can edit an item's price by filling out a form" do
      visit edit_merchant_item_path(@item)

      expect(current_path).to eq("/dashboard/items/#{@item.id}/edit")

      new_price = "3.23"

      fill_in "item[price]", with: new_price

      click_on "Update Item"

      expect(current_path).to eq(merchant_items_path)

      expect(page).to have_content("#{@item.reload.name} has been updated")
      expect(@item.reload.price.to_f).to eq(new_price.to_f)

      within("#item-#{@item.id}") do
        expect(page).to have_content(number_to_currency(new_price))
      end
    end

    it "I can edit an item's inventory by filling out a form" do
      visit edit_merchant_item_path(@item)

      expect(current_path).to eq("/dashboard/items/#{@item.id}/edit")

      new_inventory = 42

      fill_in "item[inventory]", with: new_inventory

      click_on "Update Item"

      expect(current_path).to eq(merchant_items_path)

      expect(page).to have_content("#{@item.reload.name} has been updated")
      expect(@item.reload.inventory).to eq(new_inventory)

      within("#item-#{@item.id}") do
        expect(page).to have_content("#{new_inventory} in stock")
      end
    end

    it "I cannot leave the name field blank" do
      visit edit_merchant_item_path(@item)

      fill_in "item[name]", with: ""
      click_on "Update Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Name can't be blank")
    end

    xit "I cannot leave the description field blank" do
      visit edit_merchant_item_path(@item)

      fill_in "item[description]", with: ""
      click_on "Update Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Description can't be blank")
    end

    xit "I cannot leave the price field blank" do
      visit edit_merchant_item_path(@item)

      fill_in "item[price]", with: ""
      click_on "Update Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Price can't be blank")
    end

    xit "I cannot leave the inventory field blank" do
      visit edit_merchant_item_path(@item)

      fill_in "item[inventory]", with: ""
      click_on "Update Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Inventory can't be blank")
    end

    xit "I can leave thumbnail URL blank" do
      visit edit_merchant_item_path(@item)

      expect(current_path).to eq('/dashboard/items/new')

      fill_in "item[image]", with: ""
      click_on "Update Item"

      expect(current_path).to eq(merchant_items_path)

      expect(page).to have_content("#{@item.name} has been updated")

      within("#item-#{@item.id}") do
        expect(page).to have_css("img[src*='#{Item::DEFAULT_IMAGE}']")
      end
    end

    xit "Price must be > 0.00" do
      visit edit_merchant_item_path(@item)

      fill_in "item[price]", with: "-5.0"
      click_on "Update Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Price must be greater than or equal to 0.01")

      fill_in "item[price]", with: "0.00"
      click_on "Update Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Price must be greater than or equal to 0.01")
    end

    it "Inventory must be an integer >= 0" do
      visit edit_merchant_item_path(@item)

      fill_in "item[inventory]", with: "-6"
      click_on "Update Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Inventory must be greater than or equal to 0")

      fill_in "item[inventory]", with: "5.6"
      click_on "Update Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Inventory must be an integer")
    end
  end
end
