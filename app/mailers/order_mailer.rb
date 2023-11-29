class OrderMailer < ApplicationMailer
  def shipping_email(order_id)
    @order = Order.with_shipping_address.find_by(id: order_id)
    @customer = Customer.find_by(id: @order.customer_id)
    mail(to: @customer.email, subject: 'Your Order Shipped!')
  end
end
