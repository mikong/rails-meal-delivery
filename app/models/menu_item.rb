class MenuItem < ApplicationRecord
  belongs_to :restaurant
  belongs_to :tag

  validates :name, presence: true

  monetize :price_cents

  after_create :increment_tagging
  after_destroy :decrement_tagging
  after_update :check_tagging

  private

    def increment_tagging
      tagging = Tagging.find_or_create_by(restaurant: self.restaurant, tag: self.tag)
      tagging.increment!(:taggings_count, 1)
    end

    def decrement_tagging
      decrement_tagging_by(self.tag.id)
    end

    def decrement_tagging_by(tid)
      tagging = Tagging.find_by(restaurant: self.restaurant, tag_id: tid)
      if tagging.present?
        if tagging.taggings_count > 1
          tagging.decrement!(:taggings_count, 1)
        else
          tagging.destroy
        end
      end
    end

    def check_tagging
      return unless self.tag_id_previously_changed?

      decrement_tagging_by(self.tag_id_previous_change[0])
      increment_tagging
    end
end
