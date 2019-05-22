require 'rails_helper'

RSpec.describe Cart do
  subject { Cart.new({'1' => 2, '2' => 3}) }

  describe "#total_count" do
    it "calculates the total number of items it holds" do
      expect(subject.total_count).to eq(5)
    end
  end

  describe "#add_item" do
    it "adds a item to its contents" do
      subject.add_item(1)
      subject.add_item(2)

      expect(subject.contents).to eq({'1' => 3, '2' => 4})
    end

    it "adds a item that hasn't been added yet" do
      subject.add_item('3')

      expect(subject.contents).to eq({'1' => 2, '2' => 3, '3' => 1})
    end
  end

  describe "#subtotal" do
    it "calculates the subtotal for a particular item" do
      item_1 = create(:item)
      item_2 = create(:item)
      cart_1 = Cart.new({item_1.id.to_s => 2, item_2.id.to_s => 3})

      expect(cart_1.subtotal(item_1)).to eq(2 * item_1.price)
      expect(cart_1.subtotal(item_2)).to eq(3 * item_2.price)
    end
  end

  describe "#grand_total" do
    it "calculates the grand total cost for all items" do
      item_1 = create(:item)
      item_2 = create(:item)
      cart_1 = Cart.new({item_1.id.to_s => 2, item_2.id.to_s => 3})

      expect(cart_1.grand_total).to eq(2 * item_1.price + 3 * item_2.price)
    end
  end
end
