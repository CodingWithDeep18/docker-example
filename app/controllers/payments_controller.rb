class PaymentsController < ApplicationController
  def new; end

  def create_session
    session = Stripe::Checkout::Session.create({
                                                 customer_email: 'customer@example.com',
                                                 line_items: [
                                                   {
                                                     price_data: {
                                                       currency: 'inr',
                                                       product_data: { name: 'Iphone 15 pro' },
                                                       unit_amount: 80_000 * 100
                                                     },
                                                     quantity: 1
                                                   }
                                                 ],
                                                 mode: 'payment',
                                                 success_url: "#{ENV['DOMAIN']}/success",
                                                 cancel_url: "#{ENV['DOMAIN']}/cancel"
                                               })
    redirect_to session.url, allow_other_host: true
  rescue StandardError => e
    redirect_to new_payment_path, notice: e.message
  end

  def success
    session.clear
  end

  def cancel; end
end
