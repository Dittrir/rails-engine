class Item < ApplicationRecord
  belongs_to :merchant

  validates :name,
            :presence => {message: "can't be blank"}
  validates :description,
            :presence => {message: "can't be blank"}
  validates :unit_price,
            :presence => {message: "can't be blank"},
            :numericality => true
end
