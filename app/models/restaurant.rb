class Restaurant < ApplicationRecord
  has_many :menu_items
  has_many :taggings
  has_many :tags, through: :taggings

  validates :name, presence: true

  def cheapest_menu_item_by(tag_id)
    taggings.find_by(tag_id: tag_id).try(:lowest_item)
  end
end
