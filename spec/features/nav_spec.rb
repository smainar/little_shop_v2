require 'rails_helper'

RSpec.describe "navigation bar", type: :feature do
  it 'visitor navigation' do
    visit items_path

    within("#nav") do
      click_link "Home"
      expect(current_path).to eq(root_path)

      click_link "Browse All Items"
      expect(current_path).to eq(items_path)

      # click_link "Browse All Merchants"
      # expect(current_path).to eq("/merchants")

      # click_link "My Cart"
      # expect(current_path).to eq("/cart")

      click_link "Login"
      expect(current_path).to eq(login_path)

      click_link "Register"
      expect(current_path).to eq("/register")
    end

    # Next to the shopping cart link I see a count of the items in my cart
  end
end