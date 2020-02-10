# frozen_string_literal: true

require 'test_helper'

class MenuItemTest < ActiveSupport::TestCase
  setup do
    @restaurant = create(:restaurant)
  end

  test 'should save valid menu item' do
    menu_item = MenuItem.new(
      name: 'Bulalo',
      price: 20,
      tag: tags(:meat),
      restaurant: @restaurant
    )
    menu_item.save
    assert menu_item.persisted?
  end

  test 'should increment tagging count' do
    menu_item = create(:menu_item,
      restaurant: @restaurant,
      tag: tags(:meat))
    tagging = menu_item.find_restaurant_tagging
    assert_equal 1, tagging.taggings_count

    create(:menu_item,
      restaurant: @restaurant,
      tag: tags(:meat))
    tagging.reload
    assert_equal 2, tagging.taggings_count
  end

  test 'should decrement tagging count' do
    menu_items = create_list(:menu_item, 3,
      restaurant: @restaurant,
      tag: tags(:chicken))
    tagging = menu_items.first.find_restaurant_tagging
    assert_equal 3, tagging.taggings_count

    menu_items.pop.destroy
    tagging.reload
    assert_equal 2, tagging.taggings_count

    menu_items.pop.destroy
    tagging.reload
    assert_equal 1, tagging.taggings_count

    menu_items.pop.destroy
    assert_raises(ActiveRecord::RecordNotFound) do
      tagging.reload
    end
  end
end
