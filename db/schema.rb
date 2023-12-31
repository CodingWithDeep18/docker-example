# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_231_127_082_302) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'customers', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.string 'stripe_customer_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_customers_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_customers_on_reset_password_token', unique: true
  end

  create_table 'line_items', force: :cascade do |t|
    t.bigint 'product_id', null: false
    t.integer 'quantity'
    t.bigint 'order_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['order_id'], name: 'index_line_items_on_order_id'
    t.index ['product_id'], name: 'index_line_items_on_product_id'
  end

  create_table 'orders', force: :cascade do |t|
    t.string 'total_amount'
    t.string 'status'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'stripe_checkout_id'
    t.bigint 'customer_id'
    t.index ['customer_id'], name: 'index_orders_on_customer_id'
  end

  create_table 'products', force: :cascade do |t|
    t.string 'name'
    t.decimal 'price'
    t.text 'description'
    t.integer 'qty'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'shipping_addresses', force: :cascade do |t|
    t.string 'city'
    t.string 'country'
    t.string 'line1'
    t.string 'line2'
    t.string 'postal_code'
    t.string 'state'
    t.bigint 'order_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['order_id'], name: 'index_shipping_addresses_on_order_id'
  end

  add_foreign_key 'line_items', 'orders'
  add_foreign_key 'line_items', 'products'
  add_foreign_key 'orders', 'customers'
  add_foreign_key 'shipping_addresses', 'orders'
end
