class ChangeProductnameToNameInProducts < ActiveRecord::Migration[7.1]
  def change
    rename_column :products, :productname, :name
  end
end
