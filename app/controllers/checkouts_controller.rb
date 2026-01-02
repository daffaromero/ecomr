class CheckoutsController < ApplicationController
  def create
      product = Product.find(params[:product_id])
      @session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          name: product.name,
          amount: (product.price * 100).to_i,
          currency: 'usd',
          quantity: 1
        }],
        mode: 'payment',
        success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
        cancel_url: checkout_cancel_url
      )

    respond_to do |format|
      format.js
    end
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
  end

  def cancel
    # Stripe handles this so we show a simple alert
    flash[:alert] = "Payment was cancelled."
  end
end
