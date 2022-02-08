class Merchant < ApplicationRecord
  has_many :items

  validates :name,
            :presence => {message: "can't be blank"}
end
