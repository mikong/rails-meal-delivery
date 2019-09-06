class AddLowestPriceToTaggings < ActiveRecord::Migration[5.2]
  def change
    add_monetize :taggings, :lowest_price
  end
end
