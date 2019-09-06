class Tagging < ApplicationRecord
  belongs_to :restaurant
  belongs_to :tag

  monetize :lowest_price_cents
end
