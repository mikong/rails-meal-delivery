# frozen_string_literal: true

require 'test_helper'

class MenuItemTest < ActiveSupport::TestCase
  setup do
    @restaurant = create(:restaurant)
  end

  def assert_lowest_item(menu_item, tagging)
    assert_equal menu_item, tagging.lowest_item
    assert_equal menu_item.price, tagging.lowest_price
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

  test 'should create tagging on create of first item' do
    attrs = { restaurant: @restaurant, tag: tags(:meat) }
    create(:menu_item, attrs)
    tagging = Tagging.find_by(attrs)
    assert_not_nil tagging

    create(:menu_item, attrs)
    taggings = Tagging.where(attrs)
    assert_equal 1, taggings.size
  end

  test 'should delete tagging on delete of last item' do
    attrs = { restaurant: @restaurant, tag: tags(:chicken) }
    menu_items = create_list(:menu_item, 2, attrs)
    tagging = Tagging.find_by(attrs)
    assert_not_nil tagging

    menu_items.pop.destroy
    tagging.reload

    menu_items.pop.destroy
    assert_raises(ActiveRecord::RecordNotFound) do
      tagging.reload
    end
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

  test 'should track cheapest when changing tags' do
    attrs = { restaurant: @restaurant, tag: tags(:meat) }
    not_meat = create(:menu_item, attrs.merge(price: 5))
    meat = create(:menu_item, attrs.merge(price: 10))
    chicken = create(:menu_item, attrs.merge(tag: tags(:chicken), price: 15))

    meat_tagging = meat.find_restaurant_tagging
    assert_lowest_item not_meat, meat_tagging
    chicken_tagging = chicken.find_restaurant_tagging
    assert_lowest_item chicken, chicken_tagging

    # Change tag from meat to chicken
    not_meat.update(tag: tags(:chicken))
    meat_tagging.reload
    assert_lowest_item meat, meat_tagging
    chicken_tagging.reload
    assert_lowest_item not_meat, chicken_tagging
  end

  test 'should track cheapest when price changes' do
    attrs = { restaurant: @restaurant, tag: tags(:meat) }
    item_a = create(:menu_item, attrs.merge(price: 5))
    item_b = create(:menu_item, attrs.merge(price: 10))

    tagging = item_b.find_restaurant_tagging
    assert_lowest_item item_a, tagging

    # Cheapest changes price but still cheapest
    item_a.update(price: rand(3..7))
    tagging.reload
    assert_lowest_item item_a, tagging

    # More expensive changes price but still more expensive
    item_b.update(price: rand(8..12))
    tagging.reload
    assert_lowest_item item_a, tagging

    # Cheapest becomes more expensive
    item_a.update(price: 15)
    tagging.reload
    assert_lowest_item item_b, tagging

    # More expensive becomes cheapest
    item_a.update(price: 7)
    tagging.reload
    assert_lowest_item item_a, tagging
  end
end
