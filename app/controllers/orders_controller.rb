class OrdersController < ApplicationController
  def new
    @pagy, @products = pagy(Product.all)
  end

  def create_payment
    if session[:cart_products].blank?
      return redirect_to new_order_path,
                         notice: 'Please add at least one product to cart!'
    end

    session = Stripe::Checkout::Session.create({
                                                 customer_email: 'customer@example.com',
                                                 line_items: prepare_line_items_hash,
                                                 mode: 'payment',
                                                 meta_data: {},
                                                 shipping_address_collection: { allowed_countries: %w[US IN] },
                                                 success_url: "#{ENV['DOMAIN']}/success",
                                                 cancel_url: "#{ENV['DOMAIN']}/cancel"
                                               })
    redirect_to session.url, allow_other_host: true
  end

  private

  def prepare_line_items_hash
    order_products = session[:cart_products]
    line_items = []
    order_products.each do |order_product|
      product = Product.find_by(id: order_product['product_id'])
      final_quantity = order_product['quantity'].to_i * product.qty
      line_items.push(
        {
          price_data: {
            currency: 'inr',
            product_data: { name: product.name },
            unit_amount: (final_quantity * product.price.to_i) * 100
          },
          quantity: final_quantity
        }
      )
    end
    line_items
  end
end
