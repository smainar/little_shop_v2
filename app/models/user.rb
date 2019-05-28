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

  def self.all_merchants
    where(role: 'merchant')
  end

  def self.regular_users
    where(role: 'user').order(:name)
  end

  def top_five_items
    items.select("items.* , sum(order_items.quantity) as total_sold")
         .joins(:orders)
         .group(:id)
         .where("orders.status = 2" )
         .order("total_sold desc")
         .limit(5)
    end

    def total_sold
      items.joins(:orders)
            .where(active: true)
            .where("orders.status = 2")
            .sum("order_items.quantity")
    end

    def total_inventory
      items.where(active: true).sum(:inventory)
    end

    def inventory_ratio
      (total_sold / total_inventory.to_f) * 100
    end

    def top_three_states
      items.select("users.state, sum(order_items.quantity) as total_quantity")
      .joins(:orders)
      .joins("join users On orders.user_id = users.id")
      .group("users.state")
      .where("orders.status = 2")
      .where("order_items.fulfilled = true")
      .order("total_quantity desc")
      .limit(3)
    end

    def top_three_cities
      items.select("users.city, users.state, sum(order_items.quantity) as total_quantity")
      .joins(:orders)
      .joins("join users On orders.user_id = users.id")
      .group("users.city", "users.state")
      .where("orders.status = 2")
      .order("total_quantity desc")
      .limit(3)
    end

    def top_user_orders
      select("users.name, count(orders.id) as total_orders")
      .joins(:orders)
      .joins("join users On orders.user_id = users.id")
      .joins("join  ")
      .group(:id)
      .where("orders.status = 2")
      .order("total_orders")
      .limit(1)
    end
end
