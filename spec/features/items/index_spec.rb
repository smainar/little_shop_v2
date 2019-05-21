require 'rails_helper'

RSpec.describe "As a visitor, " do
  before :each do
    @item_1 = Item.create!(name: 'Item 1', active: true, price: 1.00, description: 'Stuff 1', image: 'https://luciteacrylic.com/wp-content/uploads/2018/01/Product-Image-Coming-Soon.png', inventory: 1)
    @item_2 = Item.create!(name: 'Item 2', active: true, price: 2.00, description: 'Stuff 2', image: 'https://luciteacrylic.com/wp-content/uploads/2018/01/Product-Image-Coming-Soon.png', inventory: 2)
    @item_3 = Item.create!(name: 'Item 3', active: true, price: 3.00, description: 'Stuff 3', image: 'https://luciteacrylic.com/wp-content/uploads/2018/01/Product-Image-Coming-Soon.png', inventory: 3)

    @item_4 = Item.create!(name: 'Item 4', active: false, price: 4.00, description: 'Stuff 4', image: 'https://luciteacrylic.com/wp-content/uploads/2018/01/Product-Image-Coming-Soon.png', inventory: 4)
    @item_5 = Item.create!(name: 'Item 5', active: false, price: 5.00, description: 'Stuff 5', image: 'https://luciteacrylic.com/wp-content/uploads/2018/01/Product-Image-Coming-Soon.png', inventory: 5)

  end
  it "I see all items" do
    visit items_path

    within "test-items-index-#{@item_1}" do
      expect(page).to have_content("Name: #{@item_1.name}")
      expect(page).to have_content("Price: $#{@item_1.price}")
      expect(page).to have_content("Description: #{@item_1.description}")
      expect(page).to have_content(@item_1.image)
      expect(page).to have_content("Inventory: #{@item_1.inventory}")
    end

    within "test-items-index-#{@item_2}" do
      expect(page).to have_content("Name: #{@item_2.name}")
      expect(page).to have_content("Price: $#{@item_2.price}")
      expect(page).to have_content("Description: #{@item_2.description}")
      expect(page).to have_content(@item_2.image)
      expect(page).to have_content("Inventory: #{@item_2.inventory}")
    end
  end
end
