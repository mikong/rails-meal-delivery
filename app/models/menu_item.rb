class MenuItem < ApplicationRecord
  belongs_to :tag

  monetize :price_cents

end
