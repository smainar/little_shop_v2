class Item < ApplicationRecord
  validates_presence_of :name,
                       :price,
                       :description,
                       :image,
                       :inventory

  belongs_to :user
  has_many :order_items
  has_many :orders, through: :order_items

  DEFAULT_IMAGE = "https://www.ultimate-realty.com/wp-content/uploads/sites/6518/2019/04/Image-Coming-Soon.png"

  def self.active_items
    self.where(active: true)
  end

  def average_fulfillment_time
    order_items.average("updated_at - created_at").to_i
  end
end
