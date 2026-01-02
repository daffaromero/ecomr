class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.order(created_at: :desc) # List orders for the current user
  end

  def show
    @order = current_user.orders.find(params[:id])
  end
end
