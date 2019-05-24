require 'rails_helper'

RSpec.describe "visitors must register or log in to check out" do
  context "when I have items in my cart" do
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

    it "displays information telling me I must register or log in to finish the checkout process" do
      visit cart_path

      expect(page).to have_content("Cart: 3")
      expect(page).to have_content("You must register or log in to finish the checkout process.")

      within "#visitor-checkout" do
        expect(page).to have_link("register")
        click_on "register"
        expect(current_path).to eq(register_path)
      end

      visit cart_path

      within "#visitor-checkout" do
        expect(page).to have_link("log in")
        click_on "log in"
        expect(current_path).to eq(login_path)
      end
    end

    it "does not display log in or register information for a logged-in user" do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit cart_path

      expect(page).to have_content("Cart: 3")

      expect(page).to_not have_content("You must register or log in to finish the checkout process.")
      expect(page).to_not have_link("register")
      expect(page).to_not have_link("log in")
    end
  end
end
