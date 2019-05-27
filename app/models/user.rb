class User < ApplicationRecord
  before_save { self.email = email.downcase }

  validates_presence_of :email,
                        :name,
                        :address,
                        :city,
                        :state,
                        :zip,
                        :role
  has_many :orders
  has_many :items

  enum role: ['user', 'merchant', 'admin']

  validates :email, uniqueness: true, presence: true
  validates_presence_of :password_digest

  has_secure_password

  def self.active_merchants
    where(active: true, role: 'merchant').order(:name)
  end

  def self.inactive_merchants
    where(active: false, role: 'merchant')
  end

  def self.top_3_by_revenue
    self.joins(items: :order_items)
        .joins("JOIN orders ON order_items.order_id = orders.id")
        .group(:id)
        .select("users.*, SUM(order_items.quantity * order_items.price_per_item) AS total_revenue")
        .where(active: true)
        .where("orders.status = 2")
        .order("total_revenue DESC")
        .limit(3)
  end

  def total_revenue
    items.joins(:order_items)
         .joins("JOIN orders ON order_items.order_id = orders.id")
         .where("orders.status = 2")
         .sum("order_items.quantity * order_items.price_per_item")
  end
end
