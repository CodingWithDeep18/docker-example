class CsvImportService
  require 'csv'

  def call(file)
    opened_file = File.open(file)
    options = { headers: true }
    CSV.foreach(opened_file, **options) do |row|
      # map the CSV columns to your database columns
      product_hash = {}
      product_hash[:name] = row[0]
      product_hash[:price] = row[1]
      product_hash[:description] = row[2]
      product_hash[:qty] = row[3]

      Product.find_or_create_by!(product_hash)
      # for performance, you could create a separate job to import each user
      # CsvImportJob.perform_later(user_hash)
    end
  end
end
