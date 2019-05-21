require 'rails_helper'

RSpec.describe Item, type: :model do

  describe 'validates' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :price}
    it {should validate_presence_of :description}
    it {should validate_presence_of :image}
    it {should validate_presence_of :inventory}
  end

  describe 'relationships' do
    it {should belong_to :user}
    it {should have_many(:orders).through(:order_items)}
  end

  describe 'class methods' do
    before :each do
      @user_1 = User.create!(name: 'User 1', email: 'user_1@email.com', password_digest: 'password1', active: true, address: '1 Street', city: 'City 1', state: 'CO', zip: '00001', role: 1)
      @user_2 = User.create!(name: 'User 2', email: 'user_2@email.com', password_digest: 'password2', active: true, address: '2 Street', city: 'City 2', state: 'CO', zip: '00002', role: 1)

      @item_1 = @user_1.items.create!(name: 'Item 1', active: true, price: 1.00, description: 'Stuff 1', image: 'https://luciteacrylic.com/wp-content/uploads/2018/01/Product-Image-Coming-Soon.png', inventory: 1)
      @item_2 = @user_1.items.create!(name: 'Item 2', active: true, price: 2.00, description: 'Stuff 2', image: 'https://luciteacrylic.com/wp-content/uploads/2018/01/Product-Image-Coming-Soon.png', inventory: 2)
      @item_3 = @user_2.items.create!(name: 'Item 3', active: true, price: 3.00, description: 'Stuff 3', image: 'https://luciteacrylic.com/wp-content/uploads/2018/01/Product-Image-Coming-Soon.png', inventory: 3)

      @item_4 = @user_2.items.create!(name: 'Item 4', active: false, price: 4.00, description: 'Stuff 4', image: 'https://luciteacrylic.com/wp-content/uploads/2018/01/Product-Image-Coming-Soon.png', inventory: 4)
      @item_5 = @user_1.items.create!(name: 'Item 5', active: false, price: 5.00, description: 'Stuff 5', image: 'https://luciteacrylic.com/wp-content/uploads/2018/01/Product-Image-Coming-Soon.png', inventory: 5)
    end

    it "can filter active items only" do
      expect(Item.active_items).to eq([@item_1, @item_2, @item_3])
    end
  end
end
