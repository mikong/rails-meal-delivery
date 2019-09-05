class CreateTaggings < ActiveRecord::Migration[5.2]
  def change
    create_table :taggings do |t|
      t.belongs_to :restaurant, foreign_key: true
      t.belongs_to :tag, foreign_key: true
      t.integer :taggings_count, default: 0, null: false

      t.timestamps
    end
  end
end
