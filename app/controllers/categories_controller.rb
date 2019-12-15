class CategoriesController < ApplicationController
	before_action :load_category

	def fetch_products
		@products = @category.products.includes(:currency)

		html = render_to_string('shared/_products_page', formats: :html, layout: false)

		respond_to do |format|
      format.json { render json: { html: html }, status: 200 }
    end
	end

	private

	def load_category
		@category = Category.find(category_id)
	end

	def category_id 
		params.require(:category_id)
	end
end
