require 'rails_helper'

RSpec.describe "Cart checkout functionality: " do
  describe "as a logged in user" do
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

    it "I see a button to check out" do
      visit cart_path

      expect(page).to have_button("Check Out")
    end

    it "I can check out and see my order" do
      visit cart_path
      click_button 'Check Out'

      expect(page).to have_content("Your order was created!")
    end
  end
end


# And I click the button or link to check out
# An order is created in the system, which has a status of "pending"
# I am taken to my orders page ("/profile/orders")
# I see a flash message telling me my order was created
# I see my new order listed on my profile orders page
# My cart is now empty
