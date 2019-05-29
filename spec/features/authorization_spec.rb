require 'rails_helper'

RSpec.describe "Where certain users can't go" do

  describe "as a visitor" do
    it 'when I visit user profile I get 404' do
      visit profile_path

      expect(page.status_code).to eq(404)
    end

    it 'when i visit any dashboard path I get 404' do
      visit merchant_dashboard_path

      expect(page.status_code).to eq(404)
    end

    it 'when i visit any admin path i get 404' do
      visit admin_dashboard_path

      expect(page.status_code).to eq(404)

      visit admin_merchants_path

      expect(page.status_code).to eq(404)
    end
  end
  describe 'as a registered user' do
    before :each do
      @user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'when i visit any dashboard path i get 404' do
      visit merchant_dashboard_path

      expect(page.status_code).to eq(404)
    end

    it 'when i visit any admin path i get 404' do
      visit admin_dashboard_path

      expect(page.status_code).to eq(404)

      visit admin_merchants_path

      expect(page.status_code).to eq(404)
    end
  end

  describe 'as a merchant' do
    before :each do
      @user = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'when I visit user profile I get 404' do
      visit profile_path

      expect(page.status_code).to eq(404)
    end

    it 'when I visit any admin path i get 404' do
      visit admin_dashboard_path

      expect(page.status_code).to eq(404)

      visit admin_merchants_path

      expect(page.status_code).to eq(404)
    end

    it 'when I visit any cart path i get 404' do
      visit cart_path

      expect(page.status_code).to eq(404)
    end
  end

  describe 'as an admin' do
    before :each do
      @user = create(:admin)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'when I visit user profile I get 404' do
      visit profile_path

      expect(page.status_code).to eq(404)
    end

    it 'when i visit any dashboard path i get 404' do
      visit merchant_dashboard_path

      expect(page.status_code).to eq(404)
    end

    it 'when I visit any cart path i get 404' do
      visit cart_path

      expect(page.status_code).to eq(404)
    end
  end
end
