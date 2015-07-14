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

ActiveRecord::Schema.define(version: 20150714202052) do

  create_table "callouts", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "conversation_id"
    t.integer  "creator_id"
    t.integer  "target_id"
  end

  add_index "callouts", ["conversation_id"], name: "index_callouts_on_conversation_id"
  add_index "callouts", ["creator_id"], name: "index_callouts_on_creator_id"
  add_index "callouts", ["target_id"], name: "index_callouts_on_target_id"

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.text     "title"
    t.text     "content"
  end

  add_index "posts", ["conversation_id"], name: "index_posts_on_conversation_id"
  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "supports", force: :cascade do |t|
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "supportable_id"
    t.string   "supportable_type"
    t.integer  "creator_id"
  end

  add_index "supports", ["creator_id"], name: "index_supports_on_creator_id"
  add_index "supports", ["supportable_type", "supportable_id"], name: "index_supports_on_supportable_type_and_supportable_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
