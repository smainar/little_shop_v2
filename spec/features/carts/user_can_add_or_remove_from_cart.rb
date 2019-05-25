require 'rails_helper'

RSpec.describe "As a Registered User ", type: :feature do
  before :each do
    @merchant_1 = create(:merchant)
    @item_1 = create(:item, user: @merchant_1, name: "Sofa", inventory: 2)
    @item_2 = create(:item, user: @merchant_1, name: "Chair", inventory: 2)

    visit item_path(@item_1)
    click_button "Add to Cart"

    visit item_path(@item_2)
    click_button "Add to Cart"

    visit item_path(@item_1)
    click_button "Add to Cart"
  end

  context 'I visit my cart with items ' do
    it 'I see a button or link to remove that item from my cart' do

      visit cart_path
      
      expect(page).to have_button("+")
      expect(page).to have_button("-")
      expect(page).to have_button("Remove")

      within "#item-#{@item_1.id}" do
        click_button '+'
        click_button '+'
        expect(page).to have_content("Quantity: #{@item_1.inventory}")
      end

      within "#item-#{@item_2.id}" do
        click_button 'Remove'
        expect(page).to_not have_content("#{@item_2.name}")
      end

      within "#item-#{@item_1.id}" do
        click_button '-'
        expect(page).to have_content("Quantity: #{@item_1.inventory}")
        click_button '-'
        expect(page).to_not have_content("#{@item_1.name}")
      end

    end
  end
end
