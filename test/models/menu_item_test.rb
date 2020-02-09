# frozen_string_literal: true

require 'test_helper'

class MenuItemTest < ActiveSupport::TestCase
  test 'should save valid menu item' do
    restaurant = create(:restaurant)
    menu_item = MenuItem.new(
      name: 'Bulalo',
      price: 20,
      tag: tags(:meat),
      restaurant: restaurant
    )
    menu_item.save
    assert menu_item.persisted?
  end

  test 'should increment tagging count' do
    restaurant = create(:restaurant)
    menu_item = create(:menu_item,
      restaurant: restaurant,
      tag: tags(:meat))
    tagging = menu_item.find_restaurant_tagging
    assert_equal 1, tagging.taggings_count

    create(:menu_item,
      restaurant: restaurant,
      tag: tags(:meat))
    tagging.reload
    assert_equal 2, tagging.taggings_count
  end
end
