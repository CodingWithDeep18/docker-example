# frozen_string_literal: true

class CartsController < ApplicationController
  include ProductsHelper
  def index
    cart_product_ids = session[:cart_products] ? session[:cart_products].map { |prd| prd['product_id'] } : []
    @products = Product.where(id: cart_product_ids)
    @total_price = @products.map { |prd| cart_product_quantity(prd.id) * prd.price.to_i }.sum
  end

  def add
    cart_product = find_and_set_cart_product(params[:product_id])
    @product = Product.find_by(id: params[:product_id])
    case params[:status]
    when 'add'
      add_cart_product(cart_product)
    when 'minus'
      remove_cart_product(cart_product)
    end
  end

  private

  def add_cart_product(cart_product)
    if cart_product
      cart_product['quantity'] += 1
    else
      product_hash = HashWithIndifferentAccess.new
      product_hash[:product_id] = params[:product_id]
      product_hash[:quantity] = 1
      session[:cart_products].push(product_hash)
    end
  end

  def remove_cart_product(cart_product)
    return unless cart_product

    if cart_product['quantity'].to_i == 1
      session[:cart_products].delete_if { |h| h['product_id'] == params[:product_id] }
    else
      cart_product['quantity'] -= 1
    end
  end

  def find_and_set_cart_product(product_id)
    session[:cart_products] = [] unless session[:cart_products].present?
    session[:cart_products].find { |prd| prd['product_id'] == product_id }
  end
end
