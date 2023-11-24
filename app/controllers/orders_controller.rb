class OrdersController < ApplicationController
  def index
    @pagy, @orders = pagy(
      Order.joins(:shipping_address).select("orders.*, CONCAT(line1,', ',line2,', ',city,', ',state,', ',country) as address").order(created_at: :desc), items: 5
    )
  end

  def new
    @q = Product.ransack(params[:q])
    products = params[:q].present? ? @q.result(distinct: true) : Product.all
    @pagy, @products = pagy(products)
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
            product_data: {
              name: product.name,
              metadata: { "product_id": product.id }
            },
            unit_amount: (final_quantity * product.price.to_i) * 100
          },
          quantity: final_quantity
        }
      )
    end
    line_items
  end
end
