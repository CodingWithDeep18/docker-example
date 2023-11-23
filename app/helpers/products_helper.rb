module ProductsHelper
  def cart_total_products
    session[:cart_products] ? session[:cart_products].map { |a| a['quantity'] }.sum : 0
  end

  def cart_product_quantity(prd_id)
    session[:cart_products].find { |product| product['product_id'].to_i == prd_id }['quantity'].to_i
  end
end
