class AddRestaurantToMenuItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :menu_items, :restaurant, foreign_key: true
  end
end
