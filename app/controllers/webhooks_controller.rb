class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, ENV['STRIPE_SIGNING_SECRET']
      )
    rescue JSON::ParserError => e
      # Invalid payload
      render json: { error: { message: e.message } }, status: :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render json: { error: { message: e.message, extra: 'Sig verification failed' } }, status: :bad_request
      return
    end

    # Handle the event
    case event.type
    when 'charge.failed'
      puts "charge failed-->#{event.data.object}"
    when 'charge.refunded'
      puts "charge refunded-->#{event.data.object}"
    when 'charge.succeeded'
      puts "charge succeeded-->#{event.data.object}"
    when 'checkout.session.async_payment_failed'
      puts "checkout.session.async_payment_failed'-->#{event.data.object}"
    when 'checkout.session.async_payment_succeeded'
      puts "checkout.session.async_payment_succeeded'-->#{event.data.object}"
    when 'checkout.session.completed'
      puts "checkout.session.completed'-->#{event.data.object}"
    when 'checkout.session.expired'
      puts "checkout.session.expired'-->#{event.data.object}"
    when 'invoice.paid'
      puts "invoice paid'-->#{event.data.object}"
    when 'invoice.payment_failed'
      puts "invoice payment'-->#{event.data.object}"
    when 'invoice.payment_succeeded'
      puts "invoice payment succeeded'-->#{event.data.object}"
    else
      puts "Unhandled event type: #{event.type}"
    end

    render json: { message: :success }
  end
end
