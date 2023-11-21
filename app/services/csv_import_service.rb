class CsvImportService
  require 'csv'

  def call(file)
    opened_file = File.open(file)
    options = { headers: true }
    CSV.foreach(opened_file, **options) do |row|
      # skip row if any values is empty
      next if row.to_hash.values.any?(&:nil?)

      # map the CSV columns to your database columns
      product_hash = {}
      product_hash[:name] = row[0]
      product_hash[:price] = row[1]
      product_hash[:description] = row[2]
      product_hash[:qty] = row[3]

      CsvImportJob.perform_later(product_hash)
    end
  end
end
