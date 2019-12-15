class Admin::ProductsController < AdminController
  def index
  	@products = Product.paginate(page: params[:page])
  end
end
