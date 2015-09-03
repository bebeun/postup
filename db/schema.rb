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

ActiveRecord::Schema.define(version: 20150903001718) do

  create_table "call_actions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "call_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "support",    default: "up"
  end

  add_index "call_actions", ["call_id"], name: "index_call_actions_on_call_id"
  add_index "call_actions", ["user_id"], name: "index_call_actions_on_user_id"

  create_table "calls", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "conversation_id"
    t.integer  "callable_id"
    t.string   "callable_type"
  end

  add_index "calls", ["callable_id", "callable_type", "conversation_id"], name: "index_on_calls_for_callable_conversation", unique: true
  add_index "calls", ["callable_type", "callable_id"], name: "index_calls_on_callable_type_and_callable_id"
  add_index "calls", ["conversation_id"], name: "index_calls_on_conversation_id"

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "creator_id"
  end

  add_index "conversations", ["creator_id"], name: "index_conversations_on_creator_id"

  create_table "facebook_activations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "facebook_id"
    t.string   "token"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "activated",   default: false
    t.integer  "mailnumber",  default: 0
    t.boolean  "reported",    default: false
  end

  add_index "facebook_activations", ["facebook_id"], name: "index_facebook_activations_on_facebook_id"
  add_index "facebook_activations", ["user_id"], name: "index_facebook_activations_on_user_id"

  create_table "facebooks", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "post_actions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "support",    default: "up"
  end

  add_index "post_actions", ["post_id"], name: "index_post_actions_on_post_id"
  add_index "post_actions", ["user_id"], name: "index_post_actions_on_user_id"

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
    t.integer  "identable_id"
    t.string   "identable_type"
  end

  add_index "profiles", ["identable_type", "identable_id"], name: "index_profiles_on_identable_type_and_identable_id"
  add_index "profiles", ["profileable_type", "profileable_id"], name: "index_profiles_on_profileable_type_and_profileable_id"

  create_table "twitters", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "user_actions", force: :cascade do |t|
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "supportable_id"
    t.string   "supportable_type"
    t.integer  "user_id"
    t.string   "support"
  end

  add_index "user_actions", ["supportable_type", "supportable_id"], name: "index_user_actions_on_supportable_type_and_supportable_id"
  add_index "user_actions", ["user_id"], name: "index_user_actions_on_user_id"

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
