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
    describe '::active_merchants' do
      it 'should return all active merchants' do
        active_merchant_1 = create(:merchant)
        active_merchant_2 = create(:merchant)
        inactive_merchant = create(:inactive_merchant)
        regular_active_user = create(:user)
        active_admin = create(:admin)

        expect(User.active_merchants).to eq([active_merchant_1, active_merchant_2])
      end
    end

    describe '::inactive_merchants' do
      it 'should return all inactive (disabled) merchants' do
        active_merchant = create(:merchant)
        inactive_merchant_1 = create(:inactive_merchant)
        inactive_merchant_2 = create(:inactive_merchant)
        inactive_user = create(:inactive_user)

        expect(User.inactive_merchants).to eq([inactive_merchant_1, inactive_merchant_2])
      end
    end

    describe '.all_merchants' do
      it 'should return all merchants (active and disabled)' do
        user = create(:user)
        admin = create(:admin)

        active_merchant_1 = create(:merchant)
        active_merchant_2 = create(:merchant)

        inactive_merchant_1 = create(:inactive_merchant)

        all_merchants = [active_merchant_1, active_merchant_2, inactive_merchant_1]

        expect(User.all_merchants).to eq(all_merchants)
      end
    end
  end
end
