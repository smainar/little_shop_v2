require 'rails_helper'

RSpec.describe "As a merchant, " do
  it "checks if order status was updated from 'pending' to 'packaged'" do
    user = create(:user)
    order_1 = create(:order, user: user)

    merchant = create(:merchant)
    item_1 = create(:item, user: merchant, inventory: 7)
    item_2 = create(:item, user: merchant, price: 2.00, inventory: 10)

    oi_1 = create(:order_item, item: item_1, order: order_1, quantity: 2, price_per_item: item_1.price)
    oi_2 = create(:order_item, item: item_2, order: order_1, quantity: 9, price_per_item: item_2.price)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
    visit merchant_order_path(order_1)

    expect(item_1.item_fulfilled?(order_1)).to eq(false)
    expect(order_1.status).to eq('pending')

    within "#items-index-#{item_1.id}" do
      click_on 'Fulfill Item'
    end
    item_1.reload
    expect(item_1.item_fulfilled?(order_1)).to eq(true)
    oi_1.reload
    expect(order_1.status).to eq('pending')

    within "#items-index-#{item_2.id}" do
      click_on 'Fulfill Item'
    end
    item_2.reload
    expect(item_2.item_fulfilled?(order_1)).to eq(true)

    oi_2.reload
    order_1.reload
    expect(order_1.status).to eq('packaged')
  end
end
