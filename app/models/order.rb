# order class
class Order < ApplicationRecord
  has_many :line_items, as: :itemable
end
