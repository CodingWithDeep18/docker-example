class ApplicationController < ActionController::Base
  before_action :authenticate_customer!
  include Pagy::Backend

  def after_sign_in_path_for(_resource)
    new_order_path
  end

  def after_sign_up_path_for(_resource)
    new_order_path
  end
end
