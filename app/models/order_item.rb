class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item
  validates_presence_of :quantity_price
  validates_presence_of :quantity
end
