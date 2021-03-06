# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_06_061048) do

  create_table "employees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "job_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menu_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.bigint "tag_id"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "SGD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "restaurant_id"
    t.index ["restaurant_id"], name: "index_menu_items_on_restaurant_id"
    t.index ["tag_id"], name: "index_menu_items_on_tag_id"
  end

  create_table "restaurants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "restaurant_id"
    t.bigint "tag_id"
    t.integer "taggings_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lowest_price_cents", default: 0, null: false
    t.string "lowest_price_currency", default: "SGD", null: false
    t.bigint "lowest_item_id"
    t.index ["lowest_item_id"], name: "index_taggings_on_lowest_item_id"
    t.index ["restaurant_id"], name: "index_taggings_on_restaurant_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "login"
    t.string "email"
    t.string "crypted_password"
    t.string "password_salt"
    t.string "persistence_token"
    t.string "perishable_token"
    t.integer "login_count", default: 0, null: false
    t.integer "failed_login_count", default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string "current_login_ip"
    t.string "last_login_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["perishable_token"], name: "index_users_on_perishable_token", unique: true
    t.index ["persistence_token"], name: "index_users_on_persistence_token", unique: true
  end

  add_foreign_key "menu_items", "restaurants"
  add_foreign_key "menu_items", "tags"
  add_foreign_key "taggings", "restaurants"
  add_foreign_key "taggings", "tags"
end
