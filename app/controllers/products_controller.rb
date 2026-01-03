class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :check_can_delete, only: [:destroy]

  def index
    @products = Product.active.newest_first
  end

  def show
    # @product is set by set_product before_action
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: 'Product created successfully.'
    else
      render :new
    end
  end

  def edit
    # @product is set by set_product before_action
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    if @product.soft_delete
      redirect_to products_path, notice: 'Product deleted successfully.'
    else
      redirect_to @product, alert: 'Could not delete product.'
    end
  end

  private

  def set_product
    @product = Product.active.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: 'Product not found.'
  end

  def check_can_delete
    unless current_user.can_delete?(@product)
      redirect_to @product, alert: 'You do not have permission to delete this product.'
    end

    unless @product.can_be_deleted?
      redirect_to @product, alert: 'Cannot delete product with existing orders.'
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock)
  end 
end
