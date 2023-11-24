class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true, numericality: { only_integer: false, greater_than_or_equal_to: 0 }
  validates :description, presence: true
  validates :qty, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "name", "price", "qty", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
