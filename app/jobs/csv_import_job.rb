class CsvImportJob < ApplicationJob
  queue_as :default

  def perform(product_hash)
    Product.find_or_create_by!(product_hash)
  end
end
