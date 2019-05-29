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

    it "I can add a new item by filling out a form" do
      visit new_merchant_item_path

      expect(current_path).to eq('/dashboard/items/new')

      fill_in "item[name]", with: "Big Couch"
      fill_in "item[description]", with: "It's a very large couch"
      fill_in "item[image]", with: "https://cdn.sofadreams.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/e/megasofa_leder_wohnlandschaft_big_couch_concept_beleuchtung_schwarz_1_1.jpg"
      fill_in "item[price]", with: "50.00"
      fill_in "item[inventory]", with: "75"

      click_on "Create Item"

      expect(current_path).to eq(merchant_items_path)

      new_item = Item.last

      expect(page).to have_content("#{new_item.name} has been added")

      within("#item-#{new_item.id}") do
        expect(page).to have_link(new_item.name)
        expect(page).to have_content("ID: #{new_item.id}")
        expect(page).to have_css("img[src*='#{new_item.image}']")
        expect(page).to have_content(number_to_currency(new_item.price))
        expect(page).to have_content("#{new_item.inventory} in stock")
        expect(page).to have_button("Disable Item")
      end
    end

    it "I cannot leave most field blank" do
      visit new_merchant_item_path

      expect(current_path).to eq('/dashboard/items/new')

      # DON'T fill_in "item[name]", with: "Big Couch"
      fill_in "item[description]", with: "It's a very large couch"
      fill_in "item[image]", with: "https://cdn.sofadreams.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/e/megasofa_leder_wohnlandschaft_big_couch_concept_beleuchtung_schwarz_1_1.jpg"
      fill_in "item[price]", with: "50.00"
      fill_in "item[inventory]", with: "75"

      click_on "Create Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Name can't be blank")
      expect(Item.count).to eq(0)

      fill_in "item[name]", with: "Big Couch"
      # DON'T fill_in "item[description]", with: "It's a very large couch"
      fill_in "item[image]", with: "https://cdn.sofadreams.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/e/megasofa_leder_wohnlandschaft_big_couch_concept_beleuchtung_schwarz_1_1.jpg"
      fill_in "item[price]", with: "50.00"
      fill_in "item[inventory]", with: "75"

      click_on "Create Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Description can't be blank")
      expect(Item.count).to eq(0)

      fill_in "item[name]", with: "Big Couch"
      fill_in "item[description]", with: "It's a very large couch"
      fill_in "item[image]", with: "https://cdn.sofadreams.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/e/megasofa_leder_wohnlandschaft_big_couch_concept_beleuchtung_schwarz_1_1.jpg"
      # DON'T fill_in "item[price]", with: "50.00"
      fill_in "item[inventory]", with: "75"

      click_on "Create Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Price can't be blank")
      expect(Item.count).to eq(0)

      fill_in "item[name]", with: "Big Couch"
      fill_in "item[description]", with: "It's a very large couch"
      fill_in "item[image]", with: "https://cdn.sofadreams.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/e/megasofa_leder_wohnlandschaft_big_couch_concept_beleuchtung_schwarz_1_1.jpg"
      fill_in "item[price]", with: "50.00"
      # DON'T fill_in "item[inventory]", with: "75"

      click_on "Create Item"

      expect(page).to have_field "item[description]"
      expect(page).to have_content("Inventory can't be blank")
      expect(Item.count).to eq(0)
    end

    it "I can leave thumbnail URL blank" do
      visit new_merchant_item_path

      expect(current_path).to eq('/dashboard/items/new')

      fill_in "item[name]", with: "Big Couch"
      fill_in "item[description]", with: "It's a very large couch"
      # DON'T fill_in "item[image]", with: "https://cdn.sofadreams.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/e/megasofa_leder_wohnlandschaft_big_couch_concept_beleuchtung_schwarz_1_1.jpg"
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

    it "Price must be > 0.00" do
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

    xit "Inventory must be >= 0" do
      # to-do
    end
  end
end
