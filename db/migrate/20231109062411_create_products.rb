class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :productname
      t.decimal :price
      t.text :description
      t.integer :qty

      t.timestamps
    end
  end
end
