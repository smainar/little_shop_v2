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
end
