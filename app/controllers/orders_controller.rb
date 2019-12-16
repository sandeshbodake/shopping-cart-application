class OrdersController < ApplicationController
  def place_order
    ActiveRecord::Base.transaction do
      return error_message unless current_user.present?
      order = Order.create!(user_id: current_user.id)

      order_params.each do |_vale, line_item|

        order.line_items.create!(line_item)

        current_user.cart_items.find_by(
          product_id: line_item[:product_id]
        ).destroy
      end
      return success_message if order.present?
    end
  end

  private

  def success_message
    respond_to do |format|
      format.json { render json: { info: 'Thanks For Order !' }, status: 200 }
    end
  end

  def error_message
    respond_to do |format|
      format.json { render json: { error: 'please login before add product to cart' }, status: 200 }
    end
  end

  def order_params
    params.require(:cart_item).permit!
  end
end