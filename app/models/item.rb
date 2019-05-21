class Item < ApplicationRecord
  validates_presence_of :name,
                       :price,
                       :description,
                       :image,
                       :inventory

  belongs_to :user
  has_many :order_items
  has_many :orders, through: :order_items

  def self.active_items
    self.where(active: true)
  end
end
