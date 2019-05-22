require 'rails_helper'

RSpec.describe "cart show page", type: :feature do
  context "as a visitor" do
    before(:each) do
      @merchant_1 = create(:merchant)
      @item_1 = create(:item, user: @merchant_1, name: "Sofa")
      @item_2 = create(:item, user: @merchant_1, name: "Chair")

      visit item_path(@item_1)
      click_button "Add to Cart"

      visit item_path(@item_2)
      click_button "Add to Cart"

      visit item_path(@item_1)
      click_button "Add to Cart"
    end

    it 'shows all items in the cart' do
      visit cart_path

      expect(page).to have_link("Empty Cart")

      within("#item-#{@item_1.id}") do
        expect(page).to have_link(@item_1.name)
        expect(page).to have_css("img[src*='#{@item_1.image}']")
        expect(page).to have_link(@item_1.user.name)
        expect(page).to have_content("$#{@item_1.price}")
        expect(page).to have_content("Quantity: 2")
        expect(page).to have_content("Subtotal: $#{2 * @item_1.price}")
      end

      within("#item-#{@item_2.id}") do
        expect(page).to have_link(@item_2.name)
        expect(page).to have_css("img[src*='#{@item_2.image}']")
        expect(page).to have_link(@item_2.user.name)
        expect(page).to have_content("$#{@item_2.price}")
        expect(page).to have_content("Quantity: 1")
        expect(page).to have_content("Subtotal: $#{@item_2.price}")
      end

      expect(page).to have_content("Grand Total: $#{ 2 * @item_1.price +  @item_2.price }")
    end
  end

  context "as a user" do
    before(:each) do
      @merchant_1 = create(:merchant)
      @item_1 = create(:item, user: @merchant_1, name: "Sofa")
      @item_2 = create(:item, user: @merchant_1, name: "Chair")

      @user_1 = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)

      visit item_path(@item_1)
      click_button "Add to Cart"

      visit item_path(@item_2)
      click_button "Add to Cart"

      visit item_path(@item_1)
      click_button "Add to Cart"
    end

    it 'shows all items in the cart' do
      visit cart_path

      expect(page).to have_link("Empty Cart")

      within("#item-#{@item_1.id}") do
        expect(page).to have_link(@item_1.name)
        expect(page).to have_css("img[src*='#{@item_1.image}']")
        expect(page).to have_link(@item_1.user.name)
        expect(page).to have_content("$#{@item_1.price}")
        expect(page).to have_content("Quantity: 2")
        expect(page).to have_content("Subtotal: $#{2 * @item_1.price}")
      end

      within("#item-#{@item_2.id}") do
        expect(page).to have_link(@item_2.name)
        expect(page).to have_css("img[src*='#{@item_2.image}']")
        expect(page).to have_link(@item_2.user.name)
        expect(page).to have_content("$#{@item_2.price}")
        expect(page).to have_content("Quantity: 1")
        expect(page).to have_content("Subtotal: $#{@item_2.price}")
      end

      expect(page).to have_content("Grand Total: $#{ 2 * @item_1.price +  @item_2.price }")
    end
  end
end
