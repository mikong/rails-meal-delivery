# frozen_string_literal: true

class Tagging < ApplicationRecord
  belongs_to :restaurant
  belongs_to :tag
  belongs_to :lowest_item, class_name: 'MenuItem'

  monetize :lowest_price_cents

  def assign_lowest(menu_item)
    assign_attributes(lowest_price: menu_item.price, lowest_item: menu_item)
  end
end
