class CheckoutsController < ApplicationController
  def create
    cart = current_cart
    
    if cart.empty?
      respond_to do |format|
        format.js { render js: "alert('Your cart is empty!');" }
      end
      return
    end

    line_items = cart.map do |product_id, details|
      product = Product.find(product_id)
      {
        price_data: {
          currency: 'usd',
          product_data: {
            name: product.name,
            description: product.description
          },
          unit_amount: (product.price * 100).to_i
        },
        quantity: details['quantity']
      }
    end

    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: line_items,
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
    session[:cart] = {} # Clear the cart after successful payment
  end

  def cancel
    # Stripe handles this so we show a simple alert
    flash[:alert] = "Payment was cancelled."
  end

  private

  def current_cart
    session[:cart] ||= {}
  end
end
