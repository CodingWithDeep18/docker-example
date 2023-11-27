class MainDashboardController < ApplicationController
  skip_before_action :authenticate_customer!

  def index; end
end
