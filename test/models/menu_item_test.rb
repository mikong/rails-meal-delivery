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

  test 'should update tagging count on tag change' do
    fish_dishes = create_list(:menu_item, 2,
      restaurant: @restaurant,
      tag: tags(:fish))
    vegan_dishes = create_list(:menu_item, 2,
      restaurant: @restaurant,
      tag: tags(:vegan))

    fish_tagging = fish_dishes.first.find_restaurant_tagging
    assert_equal 2, fish_tagging.taggings_count
    vegan_tagging = vegan_dishes.first.find_restaurant_tagging
    assert_equal 2, vegan_tagging.taggings_count

    fish_dish = fish_dishes.pop
    fish_dish.update(tag: tags(:vegan))
    fish_tagging.reload
    assert_equal 1, fish_tagging.taggings_count
    vegan_tagging.reload
    assert_equal 3, vegan_tagging.taggings_count
  end

  test 'should track cheapest when adding items' do
    attrs = { restaurant: @restaurant, tag: tags(:vegetarian) }
    menu_item = create(:menu_item, attrs.merge(price: 5))

    tagging = menu_item.find_restaurant_tagging
    assert_equal menu_item, tagging.lowest_item

    create(:menu_item, attrs.merge(price: 10))
    tagging.reload
    assert_equal menu_item, tagging.lowest_item

    cheaper_item = create(:menu_item, attrs.merge(price: 3))
    tagging.reload
    assert_equal cheaper_item, tagging.lowest_item
  end

  test 'should track cheapest when deleting items' do
    attrs = { restaurant: @restaurant, tag: tags(:vegan) }
    low = create(:menu_item, attrs.merge(price: 3))
    mid = create(:menu_item, attrs.merge(price: 5))
    high = create(:menu_item, attrs.merge(price: 7))

    tagging = mid.find_restaurant_tagging
    assert_equal low, tagging.lowest_item

    high.destroy
    tagging.reload
    assert_equal low, tagging.lowest_item

    low.destroy
    tagging.reload
    assert_equal mid, tagging.lowest_item
  end

  test 'should track cheapest when price changes' do
    attrs = { restaurant: @restaurant, tag: tags(:meat) }
    item_a = create(:menu_item, attrs.merge(price: 5))
    item_b = create(:menu_item, attrs.merge(price: 10))

    tagging = item_b.find_restaurant_tagging
    assert_equal item_a, tagging.lowest_item

    # Cheapest changes price but still cheapest
    item_a.update(price: rand(3..7))
    tagging.reload
    assert_equal item_a, tagging.lowest_item

    # More expensive changes price but still more expensive
    item_b.update(price: rand(8..12))
    tagging.reload
    assert_equal item_a, tagging.lowest_item

    # Cheapest becomes more expensive
    item_a.update(price: 15)
    tagging.reload
    assert_equal item_b, tagging.lowest_item

    # More expensive becomes cheapest
    item_a.update(price: 7)
    tagging.reload
    assert_equal item_a, tagging.lowest_item
  end
end
