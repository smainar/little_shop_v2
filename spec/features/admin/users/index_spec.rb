require 'rails_helper'

RSpec.describe "admin - users index page, " do
  context "as a visitor" do
    it "I get a 404" do
      visit admin_users_path

      expect(page.status_code).to eq(404)
    end
  end

  context "as a registered user" do
    it "I get a 404" do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit admin_users_path

      expect(page.status_code).to eq(404)
    end
  end

  context "as a merchant" do
    it "I get a 404" do
      merchant = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit admin_users_path

      expect(page.status_code).to eq(404)
    end
  end

  context "as an admin" do
    before :each do
      @admin = create(:admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

      @user = create(:user)
      @inactive_user = create(:inactive_user)
      @merchant = create(:merchant)
      @other_admin = create(:admin)
    end

    it "shows info for all regular users" do
      visit admin_users_path

      within("#user-#{@user.id}") do
        expect(page).to have_link(@user.name)
        expect(page).to have_content("Registered: #{Date.strptime(@user.created_at.to_s)}")
        expect(page).to have_button("Upgrade to Merchant")
      end

      within("#user-#{@inactive_user.id}") do
        expect(page).to have_link(@inactive_user.name)
        expect(page).to have_content("Registered: #{Date.strptime(@inactive_user.created_at.to_s)}")
        expect(page).to have_button("Upgrade to Merchant")
      end

      expect(page).to_not have_content(@merchant.name)
      expect(page).to_not have_content(@other_admin.name)
    end

    xit "the users' names are links to a show page" do
      # Each user's name is a link to a show page for that user ("/admin/users/5")
    end
  end
end
