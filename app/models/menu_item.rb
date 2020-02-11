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
    return if tagging.nil?

    unless tagging.taggings_count > 1
      tagging.destroy
      return
    end

    if tagging.lowest_item_id == id
      cheapest = cheapest_items.where.not(id: id).first
      tagging.assign_lowest(cheapest)
    end
    tagging.decrement(:taggings_count, 1)
    tagging.save
  end

  def check_tagging
    return unless tag_id_previously_changed?

    decrement_tagging_by(tag_id_previous_change[0])
    increment_tagging
  end

  def add_lowest_price
    tagging = find_restaurant_tagging

    return unless tagging.lowest_price > price

    tagging.assign_lowest(self)
    tagging.save
  end

  def update_lowest_price
    tagging = find_restaurant_tagging
    cheapest = cheapest_items.first

    tagging.assign_lowest(cheapest)
    tagging.save
  end

  def cheapest_items
    restaurant.menu_items
      .where(tag_id: tag.id)
      .order(:price_cents)
  end
end
