require 'rails_helper'

RSpec.describe "navigation bar", type: :feature do
  context "as a visitor" do
    it 'has working links' do
      visit items_path

      within("nav") do
        click_link "Home"
        expect(current_path).to eq(root_path)

        click_link "Browse All Items"
        expect(current_path).to eq(items_path)

        click_link "Browse All Merchants"
        expect(current_path).to eq(merchants_path)

        # click_link "My Cart"
        # expect(current_path).to eq("/cart")

        click_link "Login"
        expect(current_path).to eq(login_path)

        click_link "Register"
        expect(current_path).to eq(register_path)
      end
    end

    it "Next to the shopping cart link I see a count of the items in my cart"
  end

  context "as a user" do
    before(:each) do
      @user = User.create!(email:    "abc@def.com",
                           password: "pw123",
                           name:     "Abc Def",
                           address:  "123 Abc St",
                           city:     "NYC",
                           state:    "NY",
                           zip:      "12345"
                          )
      allow_any_instance_of(ApplicationController).to receive(:current_user)
                                                  .and_return(@user)
    end

    it 'has working links' do
      visit items_path

      within("nav") do
        click_link "Home"
        expect(current_path).to eq(root_path)

        click_link "Browse All Items"
        expect(current_path).to eq(items_path)

        click_link "Browse All Merchants"
        expect(current_path).to eq(merchants_path)

        # click_link "My Cart"
        # expect(current_path).to eq("/cart")

        expect(page).to_not have_link("Login")
        expect(page).to_not have_link("Register")

        click_link "My Profile"
        expect(current_path).to eq(profile_path)

        expect(page).to have_content "Logged in as #{@user.name}"

        click_link "Log Out"
        expect(current_path).to eq(root_path)

        expect(page).to_not have_content "Logged in as #{user.name}"
      end
    end

    it "Next to the shopping cart link I see a count of the items in my cart"
  end
end
