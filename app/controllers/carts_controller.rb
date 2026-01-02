class CartsController < ApplicationController
  # Defining basic CRUD actions for Cart resource
  def show
    @cart_items = current_cart
  end

  def add_item
    product = Product.find(params[:product_id])
    cart = current_cart
    cart[product.id.to_s] ||= { 'quantity' => 0 }
    cart[product.id.to_s]['quantity'] += 1
    session[:cart] = cart

    redirect_to cart_path, notice: "#{product.name} added to cart."
  end

  def remove_item
    cart = current_cart
    if cart[params[:product_id]]
      cart.delete(params[:product_id])
      session[:cart] = cart
      redirect_to cart_path, notice: "Item removed from cart."    
    else
      # Item not found in cart
      redirect_to cart_path, alert: "Item not found in cart."
    end
  end

  private

  def current_cart
    session[:cart] ||= {}
  end
end