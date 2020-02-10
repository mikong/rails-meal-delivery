# frozen_string_literal: true

class MenuItem < ApplicationRecord
  belongs_to :restaurant
  belongs_to :tag

  validates :name, presence: true

  monetize :price_cents

  after_create :increment_tagging, :add_lowest_price
  after_destroy :decrement_tagging
  after_update :check_tagging, :update_lowest_price

  def find_restaurant_tagging
    Tagging.find_by(restaurant: restaurant, tag: tag)
  end

  private

  def increment_tagging
    tagging = find_restaurant_tagging
    tagging.nil? ? create_tagging : tagging.increment!(:taggings_count, 1)
  end

  def create_tagging
    Tagging.create(
      restaurant: restaurant,
      tag: tag,
      taggings_count: 1,
      lowest_price: price,
      lowest_item: self
    )
  end

  def decrement_tagging
    decrement_tagging_by(tag.id)
  end

  def decrement_tagging_by(tid)
    tagging = Tagging.find_by(restaurant: restaurant, tag_id: tid)
    return  if tagging.nil?

    if tagging.taggings_count > 1
      if tagging.lowest_item_id == id
        cheapest = restaurant.menu_items
          .where(tag_id: tag.id)
          .where.not(id: id)
          .order(:price_cents)
          .first
        tagging.lowest_price = cheapest.price
        tagging.lowest_item = cheapest
      end
      tagging.decrement(:taggings_count, 1)
      tagging.save
    else
      tagging.destroy
    end
  end

  def check_tagging
    return unless tag_id_previously_changed?

    decrement_tagging_by(tag_id_previous_change[0])
    increment_tagging
  end

  def add_lowest_price
    tagging = find_restaurant_tagging
    if tagging.lowest_price > price
      tagging.update(lowest_price: price, lowest_item: self)
    end
  end

  def update_lowest_price
    tagging = find_restaurant_tagging

    cheapest = restaurant.menu_items
      .where(tag_id: tag.id)
      .order(:price_cents)
      .first

    tagging.update(lowest_price: cheapest.price, lowest_item: cheapest)
  end
end
