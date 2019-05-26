require 'rails_helper'

RSpec.describe "profile page" do
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

    it "shows my profile data" do
      visit profile_path

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)
      expect(page).to have_content(@user.address)
      expect(page).to have_content("#{@user.city}, #{@user.state}")
      expect(page).to have_content(@user.zip)
    end

    it "has a link to edit my profile data" do
      visit profile_path

      click_link "Edit My Profile or Password"

      expect(current_path).to eq(profile_edit_path)
    end

    it "displays a link to my orders" do
      visit profile_path

      click_link "My Orders"

      expect(current_path).to eq(user_orders_path)
    end
  end
end
