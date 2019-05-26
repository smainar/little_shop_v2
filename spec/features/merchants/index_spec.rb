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
end
