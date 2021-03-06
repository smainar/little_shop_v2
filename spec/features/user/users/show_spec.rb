require 'rails_helper'

RSpec.describe "profile page" do
  context "as a user" do
    before(:each) do
      @user = User.create!(email: "abc@def.com", password: "pw123", name: "Abc Def")

      @street_1 = "123 Abc St"
      @city_1 = "NYC"
      @state_1 = "NY"
      @zip_1 = "12345"
      @nickname_1 = "home"

      @street_2 = "456 Dcf St"
      @city_2 = "Portland"
      @state_2 = "Maine"
      @zip_2 = "67890"
      @nickname_2 = "work"

      @address_1 = @user.addresses.create!(street: @street_1, city: @city_1, state: @state_1, zip: @zip_1, nickname: @nickname_1)
      @address_2 = @user.addresses.create!(street: @street_2, city: @city_2, state: @state_2, zip: @zip_2, nickname: @nickname_2)

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

    it "has a button to delete an address" do
      visit profile_path

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)

      within "#address-#{@address_1.id}" do
        expect(page).to have_button("Delete Address")
        expect(page).to have_content(@address_1.street)
        expect(page).to have_content(@address_1.city)
        expect(page).to have_content(@address_1.state)
        expect(page).to have_content(@address_1.zip)
        expect(page).to have_content(@address_1.nickname)
      end

      within "#address-#{@address_2.id}" do
        expect(page).to have_button("Delete Address")

        click_button "Delete Address"

        expect(current_path).to eq(profile_path)
      end

      expect(page).to_not have_content(@street_2)
      expect(page).to_not have_content(@city_2)
      expect(page).to_not have_content(@state_2)
      expect(page).to_not have_content(@zip_2)
      expect(page).to_not have_content(@nickname_2)
    end

    it "has a button to edit an address" do

      new_street = "New Street"
      new_city = "New City"
      new_state = "New State"
      new_zip = "33333"
      new_nickname = "holiday"

      visit profile_path

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)

      within "#address-#{@address_1.id}" do
        expect(page).to have_button("Edit Address")

        expect(page).to have_content(@street_1)
        expect(page).to have_content(@city_1)
        expect(page).to have_content(@state_1)
        expect(page).to have_content(@zip_1)
        expect(page).to have_content(@nickname_1)
      end

      within "#address-#{@address_2.id}" do
        expect(page).to have_button("Edit Address")

        click_button "Edit Address"

        expect(current_path).to eq(edit_profile_address_path(@address_2))
      end

      fill_in "address[street]", with: new_street
      fill_in "address[state]", with: new_state
      fill_in "address[city]", with: new_city
      fill_in "address[zip]", with: new_zip
      fill_in "address[nickname]", with: new_nickname

      click_button "Submit Edits"
      expect(current_path).to eq(profile_path)

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)

      within "#address-#{@address_2.id}" do
        expect(page).to have_content(new_street)
        expect(page).to have_content(new_city)
        expect(page).to have_content(new_state)
        expect(page).to have_content(new_zip)
        expect(page).to have_content(new_nickname)
      end
    end
  end

  context "as a registered user" do
    it "displays a link to my orders, if I have orders placed in the system" do
      user = create(:user)
      merchant = create(:merchant)
      address = create(:address)

      order = create(:order, user: user, address: address)

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
