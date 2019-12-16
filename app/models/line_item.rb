class LineItem < ApplicationRecord
  belongs_to :itemable, polymorphic: true
end
