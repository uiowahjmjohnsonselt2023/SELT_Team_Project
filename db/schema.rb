# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20231210033358) do

  create_table "addresses", force: :cascade do |t|
    t.string   "address"
    t.string   "street"
    t.string   "zip"
    t.string   "city"
    t.string   "country"
    t.string   "state"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id"

  create_table "cart_items", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "cart_id"
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cart_items", ["cart_id"], name: "index_cart_items_on_cart_id"
  add_index "cart_items", ["product_id"], name: "index_cart_items_on_product_id"

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: :cascade do |t|
    t.string   "image_uid"
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "image_name"
  end

  add_index "images", ["product_id"], name: "index_images_on_product_id"
  add_index "images", ["user_id"], name: "index_images_on_user_id"

  create_table "orders", force: :cascade do |t|
    t.integer  "recent_purchase_id"
    t.integer  "user_id"
    t.string   "card_number"
    t.string   "card_expiration"
    t.string   "card_cvv"
    t.string   "card_zip"
    t.string   "card_state"
    t.string   "card_city"
    t.string   "card_country"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "product_tags", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "product_tags", ["product_id"], name: "index_product_tags_on_product_id"
  add_index "product_tags", ["tag_id"], name: "index_product_tags_on_tag_id"

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "price"
    t.integer  "quantity"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "discount",    default: 0
    t.boolean  "archived",    default: false
  end

  add_index "products", ["category_id"], name: "index_products_on_category_id"

  create_table "recent_purchases", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
    t.integer  "order_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_images", force: :cascade do |t|
    t.integer  "image_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_images", ["image_id"], name: "index_user_images_on_image_id"
  add_index "user_images", ["user_id"], name: "index_user_images_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.integer  "rating"
    t.boolean  "verified_seller"
    t.string   "phone_number"
    t.integer  "reviews"
    t.string   "login_type"
    t.string   "remember_digest"
    t.boolean  "loggedIn"
  end

end
