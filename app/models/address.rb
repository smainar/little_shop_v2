class Address < ApplicationRecord
  belongs_to :user
  has_many :orders
  
  validates_presence_of :street,
                        :city,
                        :state,
                        :zip,
                        :nickname
end
