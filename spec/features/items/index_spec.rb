require 'rails_helper'

RSpec.describe "As any user, " do
  before :each do
    @user_1 = User.create!(name: 'User 1', email: 'user_1@email.com', password: 'password1', active: true, address: '1 Street', city: 'City 1', state: 'CO', zip: '00001', role: "merchant")
    @user_2 = User.create!(name: 'User 2', email: 'user_2@email.com', password: 'password2', active: true, address: '2 Street', city: 'City 2', state: 'CO', zip: '00002', role: "merchant")

    @item_1 = @user_1.items.create!(name: 'Item 1', active: true, price: 1.00, description: 'Stuff 1', image: 'https://luciteacrylic.com/wp-content/uploads/2018/01/Product-Image-Coming-Soon.png', inventory: 1)
    @item_2 = @user_1.items.create!(name: 'Item 2', active: true, price: 2.00, description: 'Stuff 2', image: 'https://luciteacrylic.com/wp-content/uploads/2018/01/Product-Image-Coming-Soon.png', inventory: 2)
    @item_3 = @user_2.items.create!(name: 'Item 3', active: true, price: 3.00, description: 'Stuff 3', image: 'https://luciteacrylic.com/wp-content/uploads/2018/01/Product-Image-Coming-Soon.png', inventory: 3)

    @item_4 = @user_2.items.create!(name: 'Item 4', active: false, price: 4.00, description: 'Stuff 4', image: 'https://luciteacrylic.com/wp-content/uploads/2018/01/Product-Image-Coming-Soon.png', inventory: 4)
    @item_5 = @user_1.items.create!(name: 'Item 5', active: false, price: 5.00, description: 'Stuff 5', image: 'https://luciteacrylic.com/wp-content/uploads/2018/01/Product-Image-Coming-Soon.png', inventory: 5)
  end

  it "I see all active items only" do
    visit items_path

    within "#test-items-index-#{@item_1.id}" do
      expect(page).to have_link(@item_1.name)
      expect(page).to have_content("$#{@item_1.price}")
      expect(page).to have_content("Description: #{@item_1.description}")
      expect(page).to have_css("img[src*='#{@item_1.image}']")
      expect(page).to have_content("#{@item_1.inventory} in stock")
    end

    within "#test-items-index-#{@item_2.id}" do
      expect(page).to have_link(@item_2.name)
      expect(page).to have_content("$#{@item_2.price}")
      expect(page).to have_content("Description: #{@item_2.description}")
      expect(page).to have_css("img[src*='#{@item_2.image}']")
      expect(page).to have_content("#{@item_2.inventory} in stock")
    end

    expect(page).to_not have_content(@item_4.name)
  end
end
