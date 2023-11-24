# frozen_string_literal: true

class CreateOrderJob < ApplicationJob
  queue_as :default

  def perform(checkout_session_id)
    return if Order.find_by(stripe_checkout_id: checkout_session_id)

    create_order_from_checkout_session(checkout_session_id)
  end

  private

  def create_order_from_checkout_session(checkout_session_id)
    event_data = Stripe::Checkout::Session.retrieve(checkout_session_id)
    line_items = fetch_line_items(checkout_session_id)
    shipping_details = event_data.shipping_details.address

    order = create_order(event_data)
    create_line_items(line_items, order)
    return order.destroy if order.line_items.count.zero?

    create_shipping_address(shipping_details, order)
  end

  def fetch_line_items(checkout_session_id)
    Stripe::Checkout::Session.list_line_items(checkout_session_id).data
  end

  def create_order(event_data)
    Order.create(total_amount: event_data['amount_total'], status: 'paid', stripe_checkout_id: event_data.id)
  end

  def create_line_items(line_items, order)
    line_items.each do |li|
      stripe_product = Stripe::Product.retrieve(li.price.product)
      product_id = stripe_product.metadata.product_id.to_i
      next unless Product.find_by(id: product_id).present?

      LineItem.create!(
        product_id: product_id,
        quantity: li.quantity,
        order_id: order.id
      )
    end
  end

  def create_shipping_address(shipping_details, order)
    ShippingAddress.create(
      city: shipping_details['city'],
      country: shipping_details['country'],
      line1: shipping_details['line1'],
      line2: shipping_details['line2'],
      postal_code: shipping_details['postal_code'],
      state: shipping_details['state'],
      order_id: order.id
    )
  end
end
