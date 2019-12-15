class CartItemsController < ApplicationController
	before_action :load_cart_item

	def delete_cart_item
		@item.destroy
	end

	private

	def load_cart_item
		@item = CartItem.find(item_id)
	end

	def item_id
		params.require(:id)
	end
end
