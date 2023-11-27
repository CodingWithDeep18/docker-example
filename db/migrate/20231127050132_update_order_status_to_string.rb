class UpdateOrderStatusToString < ActiveRecord::Migration[7.1]
  def up
    change_column :orders, :status, :string
  end
end
