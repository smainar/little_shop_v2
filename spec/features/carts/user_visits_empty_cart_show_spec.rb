require 'rails_helper'

RSpec.describe "User visits show page of empty cart", type: :feature do
  it "should only display, your cart is empty" do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit root_path

    click_on "My Cart"

    expect(page).to have_content("There is nothing in your cart!")
    expect(page).to_not have_link("Empty Cart")
    expect(page).to_not have_content("Grand Total")
  end
end
