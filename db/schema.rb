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

ActiveRecord::Schema.define(version: 20140617091009) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "meters", force: true do |t|
    t.integer  "user_id"
    t.string   "meter_type"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "service_id"
  end

  create_table "metrics", force: true do |t|
    t.integer  "meter_id"
    t.float    "metric"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", force: true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.string   "address"
    t.string   "city"
    t.string   "place_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "apartment"
    t.string   "building"
  end

  create_table "service_types", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", force: true do |t|
    t.string   "title"
    t.integer  "vendor_id"
    t.integer  "service_type_id"
    t.string   "user_account"
    t.integer  "place_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tariff_template_id"
  end

  create_table "tariff_templates", force: true do |t|
    t.string   "title"
    t.integer  "service_type_id"
    t.boolean  "has_reading"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terminal_payments", force: true do |t|
    t.float    "total"
    t.float    "amount"
    t.float    "commission"
    t.string   "user_account"
    t.integer  "vendor_id"
    t.integer  "tariff_template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.float    "amount"
    t.float    "commission"
    t.integer  "status",                          default: 0
    t.text     "error"
    t.string   "place"
    t.string   "service"
    t.integer  "user_id"
    t.boolean  "multiple"
    t.integer  "included_transactions",           default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_type",                    default: 1
    t.integer  "order_id",              limit: 8
    t.string   "payment_info"
    t.integer  "vendor_id"
  end

  create_table "user_feedbacks", force: true do |t|
    t.string   "topic"
    t.string   "body"
    t.integer  "user_id"
    t.string   "new_version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "phone"
    t.string   "gender"
    t.boolean  "admin",                  default: false, null: false
    t.string   "city"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.boolean  "tutorial",               default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vendors", force: true do |t|
    t.string   "title"
    t.integer  "service_type_id"
    t.boolean  "send_metrics",          default: false
    t.float    "commission"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "commission_yandex"
    t.float    "commission_web_money"
    t.string   "regexp"
    t.integer  "shop_article_id"
    t.float    "commission_ya_card"
    t.boolean  "filter"
    t.boolean  "billing"
    t.float    "commission_ya_cash_in"
  end

  create_table "widgetables", force: true do |t|
    t.integer  "user_id"
    t.integer  "widget_id"
    t.boolean  "status",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "widgets", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "sender"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
