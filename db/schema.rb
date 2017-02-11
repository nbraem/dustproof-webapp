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

ActiveRecord::Schema.define(version: 20170211214708) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "devices", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.string   "api_key"
    t.string   "device_eui"
    t.string   "transport"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "location"
    t.boolean  "public",             default: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.uuid     "user_id"
  end

  add_index "devices", ["api_key"], name: "index_devices_on_api_key", using: :btree
  add_index "devices", ["device_eui"], name: "index_devices_on_device_eui", using: :btree
  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "incoming_messages", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.datetime "timestamp",               null: false
    t.jsonb    "body",       default: {}, null: false
  end

  add_index "incoming_messages", ["body"], name: "index_incoming_messages_on_body", using: :gin
  add_index "incoming_messages", ["timestamp"], name: "index_incoming_messages_on_timestamp", using: :btree

  create_table "measurements", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.float    "p1_ratio"
    t.float    "p2_ratio"
    t.float    "humidity"
    t.float    "temperature"
    t.datetime "timestamp",                   null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "transport"
    t.integer  "p1_count"
    t.integer  "p2_count"
    t.float    "pm25_ratio"
    t.boolean  "is_valid",    default: false, null: false
    t.uuid     "device_id"
    t.integer  "seq_num",     default: 0,     null: false
    t.integer  "loss",        default: 0,     null: false
  end

  add_index "measurements", ["device_id"], name: "index_measurements_on_device_id", using: :btree
  add_index "measurements", ["seq_num"], name: "index_measurements_on_seq_num", using: :btree

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false, null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "api_key"
    t.string   "device_eui"
  end

  add_index "users", ["api_key"], name: "index_users_on_api_key", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["device_eui"], name: "index_users_on_device_eui", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "devices", "users"
  add_foreign_key "measurements", "devices"
end
