class StaticPagesController < ApplicationController
  def home
    @categories = Category.find_each
    @products = Product.popular_products
    @cart_items = current_user.cart_items.includes(:product) if current_user
    @coupnes = current_user.coupenes if current_user

    # if logged_in?
    # end
  end

  def help

  end

  def about

  end

  def contact

  end
end
