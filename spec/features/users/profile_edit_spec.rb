require 'rails_helper'

RSpec.describe "profile edit page" do
  context "as a user" do
    before(:each) do
      @email = "abc@def.com"
      @password = "pw123"
      @name = "Abc Def"
      @address = "123 Abc St"
      @city = "New York City"
      @state = "NY"
      @zip = "12345"
      @user = User.create!(email:    @email,
                           password: @password,
                           name:     @name,
                           address:  @address,
                           city:     @city,
                           state:    @state,
                           zip:      @zip
                          )

      allow_any_instance_of(ApplicationController).to receive(:current_user)
        .and_return(@user)
    end

    it "shows a form to edit my profile data" do
      visit profile_edit_path

      expect(page).to have_field(:name)
      expect(page).to have_field(:email)
      expect(page).to have_field(:password)
      expect(page).to have_field(:password_confirmation)
      expect(page).to have_field(:address)
      expect(page).to have_field(:city)
      expect(page).to have_field(:state)
      expect(page).to have_field(:zip)

      click_button "Submit Changes"

      expect(current_path).to eq(profile_path)

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)
      expect(page).to have_content(@user.address)
      expect(page).to have_content("#{@user.city}, #{@user.state}")
      expect(page).to have_content(@user.zip)
    end

    it "I can edit my name" do
      visit profile_edit_path

      new_name = "Bob"

      fill_in :name, with: new_name
      click_button "Submit Changes"

      expect(page).to have_content(new_name)
      expect(page).to_not have_content(@name)
      expect(@user.password).to eq(@password)
    end

    it "I can edit my email" do
      visit profile_edit_path

      new_email = "Bob@Bob.com"

      fill_in :email, with: new_email
      click_button "Submit Changes"

      expect(page).to have_content(new_email)
      expect(page).to_not have_content(@email)
      expect(@user.password).to eq(@password)
    end

    it "I can edit my address" do
      visit profile_edit_path

      new_address = "7264 Blah St"

      fill_in :address, with: new_address
      click_button "Submit Changes"

      expect(page).to have_content(new_address)
      expect(page).to_not have_content(@address)
      expect(@user.password).to eq(@password)
    end

    it "I can edit my city" do
      visit profile_edit_path

      new_city = "New Orleans"

      fill_in :city, with: new_city
      click_button "Submit Changes"

      expect(page).to have_content(new_city)
      expect(page).to_not have_content(@city)
      expect(@user.password).to eq(@password)
    end

    it "I can edit my state" do
      visit profile_edit_path

      new_state = "LA"

      fill_in :state, with: new_state
      click_button "Submit Changes"

      expect(page).to have_content(new_state)
      expect(page).to_not have_content(@state)
      expect(@user.password).to eq(@password)
    end

    it "I can edit my zip" do
      visit profile_edit_path

      new_zip = "83649"

      fill_in :zip, with: new_zip
      click_button "Submit Changes"

      expect(page).to have_content(new_zip)
      expect(page).to_not have_content(@zip)
      expect(@user.password).to eq(@password)
    end
  end
end
