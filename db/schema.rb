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

ActiveRecord::Schema.define(version: 20151006185217) do

  create_table "aftf_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "creator_id"
    t.string   "support"
    t.integer  "aftf_id"
  end

  add_index "aftf_actions", ["aftf_id"], name: "index_aftf_actions_on_aftf_id"
  add_index "aftf_actions", ["creator_id"], name: "index_aftf_actions_on_creator_id"

  create_table "aftfs", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "conversation_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.boolean  "accepted"
    t.integer  "answer_call_id"
    t.string   "answer_call_type"
    t.integer  "decider_call_id"
  end

  add_index "aftfs", ["answer_call_type", "answer_call_id"], name: "index_aftfs_on_answer_call_type_and_answer_call_id"
  add_index "aftfs", ["conversation_id"], name: "index_aftfs_on_conversation_id"
  add_index "aftfs", ["creator_id"], name: "index_aftfs_on_creator_id"
  add_index "aftfs", ["decider_call_id"], name: "index_aftfs_on_decider_call_id"

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
    t.integer  "parent_id"
    t.string   "parent_type"
  end

  add_index "calls", ["callable_type", "callable_id"], name: "index_calls_on_callable_type_and_callable_id"
  add_index "calls", ["conversation_id"], name: "index_calls_on_conversation_id"
  add_index "calls", ["parent_type", "parent_id"], name: "index_calls_on_parent_type_and_parent_id"

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
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "facebooks", ["owner_type", "owner_id"], name: "index_facebooks_on_owner_type_and_owner_id"

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
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "conversation_id"
    t.text     "title"
    t.text     "content"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.boolean  "visible",         default: true
  end

  add_index "posts", ["conversation_id"], name: "index_posts_on_conversation_id"
  add_index "posts", ["parent_type", "parent_id"], name: "index_posts_on_parent_type_and_parent_id"

  create_table "potential_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "twitters", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "twitters", ["owner_type", "owner_id"], name: "index_twitters_on_owner_type_and_owner_id"

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
    t.datetime "deleted_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
