class ProductsController < ApplicationController
   before_action :authenticate_user!, except: [:index, :show]
   # Defining basic CRUD actions for Product resource

   def index
     @products = Product.all
   end

   def show
     @product = Product.find(params[:id])
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

   private

   def product_params
    params.require(:product).permit(:name, :description, :price, :stock)
   end 
end
