class MenuItem < ApplicationRecord
  belongs_to :restaurant
  belongs_to :tag

  validates :name, presence: true

  monetize :price_cents

end
