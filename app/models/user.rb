class User < ApplicationRecord
  validates_presence_of :email,
                        :active,
                        :name,
                        :address,
                        :city,
                        :state,
                        :zip
  has_many :orders
  has_many :items

  validates :email, uniqueness: true, presence: true
  validates_presence_of :password, require: true

  has_secure_password
end
