# The form is re-populated with all of this item's information
# I can change any information, but all of the rules for adding a new item still apply:
# - name and description cannot be blank
# - price cannot be less than $0.00
# - inventory must be 0 or greater
#
# When I submit the form
# I am taken back to my items page
# I see a flash message indicating my item is updated
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

    it "I can edit an item's name by filling out a form" do
      visit edit_merchant_item_path(@item)

      expect(current_path).to eq("/dashboard/items/#{@item.id}/edit")

      new_name = "Big Couch"

      fill_in "item[name]", with: new_name
      # fill_in "item[description]", with: "It's a very large couch"
      # fill_in "item[image]", with: "https://cdn.sofadreams.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/e/megasofa_leder_wohnlandschaft_big_couch_concept_beleuchtung_schwarz_1_1.jpg"
      # fill_in "item[price]", with: "50.00"
      # fill_in "item[inventory]", with: "75"

      click_on "Update Item"

      expect(current_path).to eq(merchant_items_path)

      expect(page).to have_content("#{new_name} has been updated")
      expect(@item.reload.name).to eq(new_item)

      within("#item-#{@item.id}") do
        expect(page).to have_link(new_name)
        expect(page).to have_content("ID: #{@item.id}")
        expect(page).to have_css("img[src*='#{@item.image}']")
        expect(page).to have_content(number_to_currency(@item.price))
        expect(page).to have_content("#{@item.inventory} in stock")
      end
    end

    xit "more tests for editing other fields"

    xit "I cannot leave the name field blank" do
      visit new_merchant_item_path

      # DON'T fill_in "item[name]"
      fill_in "item[description]", with: "It's a very large couch"
      fill_in "item[image]", with: "https://cdn.sofadreams.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/e/megasofa_leder_wohnlandschaft_big_couch_concept_beleuchtung_schwarz_1_1.jpg"
      fill_in "item[price]", with: "50.00"
      fill_in "item[inventory]", with: "75"

      click_on "Create Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Name can't be blank")
      expect(Item.count).to eq(0)
    end

    xit "I cannot leave the description field blank" do
      visit new_merchant_item_path

      fill_in "item[name]", with: "Big Couch"
      # DON'T fill_in "item[description]"
      fill_in "item[image]", with: "https://cdn.sofadreams.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/e/megasofa_leder_wohnlandschaft_big_couch_concept_beleuchtung_schwarz_1_1.jpg"
      fill_in "item[price]", with: "50.00"
      fill_in "item[inventory]", with: "75"

      click_on "Create Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Description can't be blank")
      expect(Item.count).to eq(0)

    end

    xit "I cannot leave the price field blank" do
      visit new_merchant_item_path

      fill_in "item[name]", with: "Big Couch"
      fill_in "item[description]", with: "It's a very large couch"
      fill_in "item[image]", with: "https://cdn.sofadreams.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/e/megasofa_leder_wohnlandschaft_big_couch_concept_beleuchtung_schwarz_1_1.jpg"
      # DON'T fill_in "item[price]"
      fill_in "item[inventory]", with: "75"

      click_on "Create Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Price can't be blank")
      expect(Item.count).to eq(0)
    end

    xit "I cannot leave the inventory field blank" do
      visit new_merchant_item_path

      fill_in "item[name]", with: "Big Couch"
      fill_in "item[description]", with: "It's a very large couch"
      fill_in "item[image]", with: "https://cdn.sofadreams.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/e/megasofa_leder_wohnlandschaft_big_couch_concept_beleuchtung_schwarz_1_1.jpg"
      fill_in "item[price]", with: "50.00"
      # DON'T fill_in "item[inventory]"

      click_on "Create Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Inventory can't be blank")
      expect(Item.count).to eq(0)
    end

    xit "I can leave thumbnail URL blank" do
      visit new_merchant_item_path

      expect(current_path).to eq('/dashboard/items/new')

      fill_in "item[name]", with: "Big Couch"
      fill_in "item[description]", with: "It's a very large couch"
      # DON'T fill_in "item[image]"
      fill_in "item[price]", with: "50.00"
      fill_in "item[inventory]", with: "75"

      click_on "Create Item"

      expect(current_path).to eq(merchant_items_path)

      new_item = Item.last

      expect(page).to have_content("#{new_item.name} has been added")

      within("#item-#{new_item.id}") do
        expect(page).to have_link(new_item.name)
        expect(page).to have_content("ID: #{new_item.id}")
        expect(page).to have_css("img[src*='#{Item::DEFAULT_IMAGE}']")
        expect(page).to have_content(number_to_currency(new_item.price))
        expect(page).to have_content("#{new_item.inventory} in stock")
        expect(page).to have_button("Disable Item")
      end
    end

    xit "Price must be > 0.00" do
      visit new_merchant_item_path

      expect(current_path).to eq('/dashboard/items/new')

      fill_in "item[name]", with: "Big Couch"
      fill_in "item[description]", with: "It's a very large couch"
      fill_in "item[image]", with: "https://cdn.sofadreams.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/e/megasofa_leder_wohnlandschaft_big_couch_concept_beleuchtung_schwarz_1_1.jpg"
      fill_in "item[price]", with: "-5.0"
      fill_in "item[inventory]", with: "75"

      click_on "Create Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Price must be greater than or equal to 0.01")
      expect(Item.count).to eq(0)

      fill_in "item[name]", with: "Big Couch"
      fill_in "item[description]", with: "It's a very large couch"
      fill_in "item[image]", with: "https://cdn.sofadreams.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/e/megasofa_leder_wohnlandschaft_big_couch_concept_beleuchtung_schwarz_1_1.jpg"
      fill_in "item[price]", with: "0.00"
      fill_in "item[inventory]", with: "75"

      click_on "Create Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Price must be greater than or equal to 0.01")
      expect(Item.count).to eq(0)
    end

    xit "Inventory must be an integer >= 0" do
      visit new_merchant_item_path

      expect(current_path).to eq('/dashboard/items/new')

      fill_in "item[name]", with: "Big Couch"
      fill_in "item[description]", with: "It's a very large couch"
      fill_in "item[image]", with: "https://cdn.sofadreams.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/e/megasofa_leder_wohnlandschaft_big_couch_concept_beleuchtung_schwarz_1_1.jpg"
      fill_in "item[price]", with: "5"
      fill_in "item[inventory]", with: "-6"

      click_on "Create Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Inventory must be greater than or equal to 0")
      expect(Item.count).to eq(0)

      fill_in "item[name]", with: "Big Couch"
      fill_in "item[description]", with: "It's a very large couch"
      fill_in "item[image]", with: "https://cdn.sofadreams.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/e/megasofa_leder_wohnlandschaft_big_couch_concept_beleuchtung_schwarz_1_1.jpg"
      fill_in "item[price]", with: "5.00"
      fill_in "item[inventory]", with: "5.6"

      click_on "Create Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Inventory must be an integer")
      expect(Item.count).to eq(0)

      fill_in "item[name]", with: "Big Couch"
      fill_in "item[description]", with: "It's a very large couch"
      fill_in "item[image]", with: "https://cdn.sofadreams.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/e/megasofa_leder_wohnlandschaft_big_couch_concept_beleuchtung_schwarz_1_1.jpg"
      fill_in "item[price]", with: "5.00"
      fill_in "item[inventory]", with: "0"

      click_on "Create Item"

      expect(current_path).to eq(merchant_items_path)

      new_item = Item.last

      expect(page).to have_content("#{new_item.name} has been added")

      within("#item-#{new_item.id}") do
        expect(page).to have_link(new_item.name)
      end
    end
  end
end
