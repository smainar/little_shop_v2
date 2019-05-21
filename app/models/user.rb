class User < ApplicationRecord
  validates_presence_of :email,
                        :password_digest,
                        :active,
                        :name,
                        :address,
                        :city,
                        :state,
                        :zip,
                        :role
  has_many :orders
  has_many :items

  has_secure_password

  enum role: ['user', 'merchant', 'admin']
end
