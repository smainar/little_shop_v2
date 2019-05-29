class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  validates_presence_of :price_per_item
  validates_presence_of :quantity

  def cancel
    if fulfilled?
      update(fulfilled: false)
      item.update(inventory: (item.inventory + quantity))
    end
  end

  def update_item_inventory
    new_inventory = item.inventory - self.quantity
    item.update(inventory: new_inventory)
  end
end
