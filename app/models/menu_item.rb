class MenuItem < ApplicationRecord
  belongs_to :restaurant
  belongs_to :tag

  validates :name, presence: true

  monetize :price_cents

  after_create :increment_tagging
  after_destroy :decrement_tagging

  private

    def increment_tagging
      tagging = Tagging.find_or_create_by(restaurant: self.restaurant, tag: self.tag)
      tagging.increment!(:taggings_count, 1)
    end

    def decrement_tagging
      tagging = Tagging.find_by(restaurant: self.restaurant, tag: self.tag)
      if tagging.present?
        if tagging.taggings_count > 1
          tagging.decrement!(:taggings_count, 1)
        else
          tagging.destroy
        end
      end
    end
end
