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
    where(active: true, role: 'merchant')
  end

  def top_five_items
    items.select("items.* , sum(order_items.quantity) as total_sold")
         .joins(:orders)
         .group(:id)
         .where("orders.status = 2" )
         .order("total_sold desc")
         .limit(5)
  end
end
