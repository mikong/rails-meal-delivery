class Restaurant < ApplicationRecord
  has_many :menu_items

  validates :name, presence: true
end
