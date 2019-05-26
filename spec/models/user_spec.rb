require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'validations' do
    it {should validate_presence_of :email}
    it {should validate_presence_of :role}
    it {should validate_presence_of :name}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}

    it {should validate_presence_of :email}
    it {should validate_presence_of :password_digest}
  end

  describe 'relationships' do
    it {should have_many :items}
    it {should have_many :orders}
  end

  describe 'Class Methods' do
    describe '.active_merchants' do
      it 'should return all active merchants' do
        active_merchant_1 = create(:merchant)
        active_merchant_2 = create(:merchant)
        inactive_merchant = create(:inactive_merchant)
        regular_active_user = create(:user)

        expect(User.active_merchants).to eq([active_merchant_1, active_merchant_2])
      end
    end

    describe '::regular_users' do
      it 'should return all regular users' do
        user_1 = create(:user)
        user_2 = create(:user)
        inactive_user = create(:inactive_user)
        active_merchant = create(:merchant)
        active_admin = create(:admin)

        expect(User.regular_users).to eq([inactive_user, user_1, user_2])
      end
    end
  end
end
