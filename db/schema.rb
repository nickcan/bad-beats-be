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

ActiveRecord::Schema.define(version: 20161204204656) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

  create_table "comments", id: false, force: true do |t|
    t.uuid     "id",         default: "gen_random_uuid()", null: false
    t.uuid     "post_id",                                  null: false
    t.uuid     "user_id",                                  null: false
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", id: false, force: true do |t|
    t.uuid     "id",             default: "gen_random_uuid()", null: false
    t.uuid     "imageable_id"
    t.string   "imageable_type"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "object_key"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", id: false, force: true do |t|
    t.uuid     "id",         default: "gen_random_uuid()", null: false
    t.uuid     "user_id",                                  null: false
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: false, force: true do |t|
    t.uuid     "id",              default: "gen_random_uuid()", null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "email"
    t.string   "name"
    t.string   "image_url"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
