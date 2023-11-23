class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_one :shipping_address, dependent: :destroy
  enum status: %i[draft paid shipped]
end
