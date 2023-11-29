class SendShippingEmailJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    OrderMailer.shipping_email(order_id).deliver_later
  end
end
