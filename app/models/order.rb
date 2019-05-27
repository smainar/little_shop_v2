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

  def total_quantity
    order_items.sum(:quantity)
  end

  def item_price(item)
    if items.include?(item)
      order_items.where(item: item).first.price_per_item
    end
  end

  def item_quantity(item)
    if items.include?(item)
      order_items.where(item: item).first.quantity
    else
      0
    end
  end

  def item_subtotal(item)
    if items.include?(item)
      order_item = order_items.where(item: item).first
      order_item.quantity * order_item.price_per_item
    else
      0
    end
  end

  def self.pending_merchant_orders(merchant)
    Order.joins(:items)
        .where(status: 0)
        .where("items.user_id = ?", merchant.id)
        .distinct
    # Order.joins(:items).where(status: 0).where("items.user_id = ?", merchant.id).group(:id).select("orders.*,order_items.*,items.name,items.user_id, SUM(order_items.quantity*order_items.price_per_item) AS total_value")
  end
end
