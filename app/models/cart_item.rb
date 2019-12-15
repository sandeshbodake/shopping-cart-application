class CartItem < ApplicationRecord
	before_save :add_amount
	belongs_to :product
	validates :product_id, presence: true

	def add_amount
		self.amount = calculate_amount
	end

	def calculate_amount
		product = Product.find(product_id)

		product.price.to_f * quantity.to_f
	end
end
