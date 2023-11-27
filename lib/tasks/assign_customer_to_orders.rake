# frozen_string_literal: true

desc 'Assign customer to orders'

namespace :order do
  task assign_customer_to_orders: :environment do
    Order.where(customer_id: nil) do |order|
      customer = Customer.find_or_create_by(email: 'test@gmail.com', password: 'password')
      order.update(customer_id: customer.id)
    end
  end
end
