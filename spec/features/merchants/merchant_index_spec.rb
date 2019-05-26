require 'rails_helper'

RSpec.describe "Merchant Index", type: :feature do
  context "as a visitor" do
    it 'should display all active merchants' do
      active_merchant_1 = create(:merchant)
      active_merchant_2 = create(:merchant)
      inactive_merchant = create(:inactive_merchant)

      visit merchants_path

      within("#merchant-id-#{active_merchant_1.id}") do
        expect(page).to have_content(active_merchant_1.name)
        expect(page).to have_content(active_merchant_1.city)
        expect(page).to have_content(active_merchant_1.state)
        expect(page).to have_content(Date.strptime(active_merchant_1.created_at.to_s))
      end
      within("#merchant-id-#{active_merchant_2.id}") do
        expect(page).to have_content(active_merchant_2.name)
        expect(page).to have_content(active_merchant_2.city)
        expect(page).to have_content(active_merchant_2.state)
        expect(page).to have_content(Date.strptime(active_merchant_2.created_at.to_s))
      end

      expect(page).to_not have_content(inactive_merchant.name)
      expect(page).to_not have_content(inactive_merchant.city)
      expect(page).to_not have_content(inactive_merchant.state)
    end
  end

  context "as an admin" do
    before(:each) do
      @admin = User.create!(email:    "abc@def.com",
                            password: "pw123",
                            name:     "Abc Def",
                            address:  "123 Abc St",
                            city:     "NYC",
                            state:    "NY",
                            zip:      "12345",
                            role:     :admin
                           )
      allow_any_instance_of(ApplicationController).to receive(:current_user)
                                                  .and_return(@admin)

      @active_merchant = create(:merchant)
      @disabled_merchant = create(:inactive_merchant)
    end

    it "shows all merchants - even inactive ones" do
      visit merchants_path

      expect(current_path).to eq("/merchants")

      within("#merchant-id-#{@active_merchant.id}") do
        expect(page).to have_link(@active_merchant.name)
        expect(page).to have_content(@active_merchant.city)
        expect(page).to have_content(@active_merchant.state)
      end

      within("#merchant-id-#{@disabled_merchant.id}") do
        expect(page).to have_link(@disabled_merchant.name)
        expect(page).to have_content(@disabled_merchant.city)
        expect(page).to have_content(@disabled_merchant.state)
      end
    end

    it "has links to all merchant dashboards" do
      # The merchant's name is a link to their Merchant Dashboard at routes such as "/admin/merchants/5"
    end

    it "has buttons to enable/disable merchants" do
      # I see a "disable" button next to any merchants who are not yet disabled
      # I see an "enable" button next to any merchants whose accounts are disabled
    end
  end
end
