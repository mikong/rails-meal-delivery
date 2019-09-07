class Tagging < ApplicationRecord
  belongs_to :restaurant
  belongs_to :tag
  belongs_to :lowest_item, class_name: "MenuItem"

  monetize :lowest_price_cents
end
