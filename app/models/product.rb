class Product < ApplicationRecord
    validates :productname, presence: true
    validates :price, presence: true, numericality: { only_integer: false, greater_than_or_equal_to: 0 }
    validates :description, presence: true
    validates :qty, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  end
  