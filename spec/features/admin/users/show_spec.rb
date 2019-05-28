require 'rails_helper'

RSpec.describe "admin user profile page", type: :feature do
  before :each do
    @admin = create(:admin)
    @user = create(:user)
    @merchant = create(:merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  it "displays the same information the user would see themselves" do
    visit admin_user_path(@user)

    within "#user-profile-#{@user.id}" do
      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)
      expect(page).to have_content(@user.address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)

      expect(page).to_not have_content(@user.password)
      expect(page).to_not have_link("Edit My Profile or Password")
    end
  end
end
