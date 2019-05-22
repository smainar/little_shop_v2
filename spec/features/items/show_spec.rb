require 'rails_helper'

RSpec.describe "As any kind of user, " do
  describe  "I visit the item show page" do
    before :each do
      @merchant_1 = create!(:merchant)
      @item_1 = @merchant_1.items(:item)
    end

    it "I can see all the information for the item" do
      visit item_path(@item_1)

      expect(current_path).to eq(item_path(@item_1))

      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_1.description)
      expect(page).to have_css("img[src*='#{@item_1.image}']")
      expect(page).to have_content(@merchant_1.name)
      #to-do need to check how many in stock.
    end
  end
end
