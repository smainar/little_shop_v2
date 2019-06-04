require 'rails_helper'

RSpec.describe "profile page" do
  context "as a user" do
    before(:each) do
      @user = User.create!(email: "abc@def.com", password: "pw123", name: "Abc Def")

      @address_1 = @user.addresses.create!(street: "123 Abc St", city: "NYC", state: "NY", zip: "12345", nickname: "home")
      @address_2 = @user.addresses.create!(street: "456 Dcf St", city: "Albany", state: "NY", zip: "67890", nickname: "work")

      allow_any_instance_of(ApplicationController).to receive(:current_user)
        .and_return(@user)
    end

    it "shows my profile data with multiple addresses" do
      visit profile_path

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)

      expect(page).to have_content(@address_1.street)
      expect(page).to have_content("#{@address_1.city}")
      expect(page).to have_content("#{@address_1.state}")
      expect(page).to have_content(@address_1.zip)
      expect(page).to have_content(@address_1.nickname)

      expect(page).to have_content(@address_2.street)
      expect(page).to have_content("#{@address_2.city}")
      expect(page).to have_content("#{@address_2.state}")
      expect(page).to have_content(@address_2.zip)
      expect(page).to have_content(@address_2.nickname)
    end

    it "has a link to edit my profile data" do
      visit profile_path

      click_link "Edit My Profile or Password"

      expect(current_path).to eq(profile_edit_path)
    end

    it "has a button to add an address" do
      name = "Abc Def"
      email = "abc@def.com"
      password = "pw123"
      street = "789 Ghi St"
      city = "Chicago"
      state = "IL"
      zip = "34567"
      nickname = "billing"

      address_3 = @user.addresses.create!(street: street, city: city, state: state, zip: zip, nickname: nickname)

      visit profile_path

      expect(page).to have_link("Add Address")
      click_link "Add Address"

      expect(current_path).to eq(new_profile_address_path)

      fill_in "address[street]", with: street
      fill_in "address[state]", with: state
      fill_in "address[city]", with: city
      fill_in "address[zip]", with: zip
      fill_in "address[nickname]", with: nickname

      click_button "Submit New Address"
      expect(current_path).to eq(profile_path)

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)

      within "#address-#{@address_1.id}" do
        expect(page).to have_content(@address_1.street)
        expect(page).to have_content(@address_1.city)
        expect(page).to have_content(@address_1.state)
        expect(page).to have_content(@address_1.zip)
        expect(page).to have_content(@address_1.nickname)
      end

      within "#address-#{@address_2.id}" do
        expect(page).to have_content(@address_2.street)
        expect(page).to have_content(@address_2.city)
        expect(page).to have_content(@address_2.state)
        expect(page).to have_content(@address_2.zip)
        expect(page).to have_content(@address_2.nickname)
      end

      within "#address-#{address_3.id}" do
        expect(page).to have_content(address_3.street)
        expect(page).to have_content(address_3.city)
        expect(page).to have_content(address_3.state)
        expect(page).to have_content(address_3.zip)
        expect(page).to have_content(address_3.nickname)
      end
    end
  end

  context "as a registered user" do
    it "displays a link to my orders, if I have orders placed in the system" do
      user = create(:user)
      merchant = create(:merchant)

      order = create(:order, user: user)

      item_1 = create(:item, user: merchant)
      item_2 = create(:item, user: merchant)

      oi_1 = create(:order_item, item: item_1, order: order, quantity: 3, price_per_item: item_1.price)
      oi_2 = create(:order_item, item: item_2, order: order, quantity: 1, price_per_item: item_2.price)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_path

      click_link "My Orders"

      expect(current_path).to eq(user_orders_path)
    end

    it "does NOT display a link to my orders, if no orders are placed in the system" do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_path

      expect(page).to_not have_link("My Orders")
    end
  end
end
