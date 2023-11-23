class AddStripeCheckoutIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :stripe_checkout_id, :string
  end
end
