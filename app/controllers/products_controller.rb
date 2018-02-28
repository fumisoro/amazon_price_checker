class ProductsController < ApplicationController
  def index
    @products = Product.all
    @product = Product.new
  end

  def create
    @product = Product.create(product_params)
    redirect_to action: :index
  end

  private
  def product_params
    params.require(:product).permit(
      :name,
      :url
    )
  end
end
