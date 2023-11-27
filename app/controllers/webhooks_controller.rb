class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_customer!

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
    when 'checkout.session.completed'
      CreateOrderJob.perform_later(event.data.object.id)
    else
      puts "Unhandled event type: #{event.type}"
    end

    render json: { message: :success }
  end
end
