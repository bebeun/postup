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

ActiveRecord::Schema.define(version: 20150716232647) do

  create_table "callouts", force: :cascade do |t|
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "conversation_id"
    t.integer  "creator_id"
    t.integer  "calloutable_id"
    t.string   "calloutable_type"
  end

  add_index "callouts", ["calloutable_type", "calloutable_id"], name: "index_callouts_on_calloutable_type_and_calloutable_id"
  add_index "callouts", ["conversation_id"], name: "index_callouts_on_conversation_id"
  add_index "callouts", ["creator_id", "calloutable_id", "calloutable_type", "conversation_id"], name: "index_on_callouts_for_creator_calloutable_conversation", unique: true
  add_index "callouts", ["creator_id"], name: "index_callouts_on_creator_id"

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "conversation_id"
    t.integer  "creator_id"
    t.text     "title"
    t.text     "content"
  end

  add_index "posts", ["conversation_id"], name: "index_posts_on_conversation_id"
  add_index "posts", ["creator_id"], name: "index_posts_on_creator_id"

  create_table "potential_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "profileable_id"
    t.string   "profileable_type"
    t.string   "description"
  end

  add_index "profiles", ["description"], name: "index_profiles_on_description", unique: true
  add_index "profiles", ["profileable_type", "profileable_id"], name: "index_profiles_on_profileable_type_and_profileable_id"

  create_table "supports", force: :cascade do |t|
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "supportable_id"
    t.string   "supportable_type"
    t.integer  "creator_id"
  end

  add_index "supports", ["creator_id", "supportable_id", "supportable_type"], name: "index_on_supports_for_creator_supportable", unique: true
  add_index "supports", ["creator_id"], name: "index_supports_on_creator_id"
  add_index "supports", ["supportable_type", "supportable_id"], name: "index_supports_on_supportable_type_and_supportable_id"

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
