class Restaurant < ApplicationRecord
  has_many :menu_items
  has_many :taggings
  has_many :tags, through: :taggings

  validates :name, presence: true
end
