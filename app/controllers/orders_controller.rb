class OrdersController < ApplicationController
  def new
    @pagy, @products = pagy(Product.all)
  end
end
