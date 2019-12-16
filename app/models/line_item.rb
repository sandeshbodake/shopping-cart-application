class LineItem < ApplicationRecord
  belongs_to :itemable, polymorphic: true
  belongs_to :product
end
