class Stripe::CreateCustomerService < ApplicationService
  def initialize(customer)
    @customer = customer
  end

  def call
    stripe_customer = Stripe::Customer.create({ email: @customer.email })
    @customer.update(stripe_customer_id: stripe_customer.id)
  rescue StandardError => e
    { error: true, message: e.message }
  end
end
