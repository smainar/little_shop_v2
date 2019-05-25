class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items

  validates_presence_of :status

  enum status: ['pending', 'packaged', 'shipped', 'cancelled']

  def grand_total
    order_items.sum do |order_item|
      order_item.price_per_item * order_item.quantity
    end
  end
end
