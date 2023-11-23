module ProductsHelper
  def cart_total_products
    session[:cart_products] ? session[:cart_products].map { |a| a['quantity'] }.sum : 0
  end
end
