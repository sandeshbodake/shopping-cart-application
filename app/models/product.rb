class Product < ApplicationRecord
  belongs_to :category
  belongs_to :currency

  def self.popular_products
  	Product.first(10)
  end
end
