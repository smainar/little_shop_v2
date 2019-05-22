require 'rails_helper'

RSpec.describe "When a visitor adds items to their cart" do
  before(:each) do
    @merchant_1 = create(:merchant)
    @item_1 = create(:item, user: @merchant_1)
    @item_2 = create(:item, user: @merchant_1)
  end

  it "displays a message" do
    visit item_path(@item_1)
    click_button "Add to Cart"

    expect(page).to have_content("You now have 1 of #{@item_1.name} in your cart.")
  end

  it "the message correctly increments for multiple items" do
    visit item_path(@item_1)
    click_button "Add to Cart"

    visit item_path(@item_2)
    click_button "Add to Cart"

    visit item_path(@item_1)
    click_button "Add to Cart"

    expect(page).to have_content("You now have 2 of #{@item_1.name} in your cart.")
  end

  it "displays the total number of items in the cart" do
    visit item_path(@item_1)

    expect(page).to have_content("Cart: 0")

    click_button "Add to Cart"

    expect(page).to have_content("Cart: 1")

    visit item_path(@item_2)
    click_button "Add to Cart"

    expect(page).to have_content("Cart: 2")

    visit item_path(@item_1)
    click_button "Add to Cart"

    expect(page).to have_content("Cart: 3")
  end
end
