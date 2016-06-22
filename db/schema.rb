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

ActiveRecord::Schema.define(version: 20151127155538) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calls", force: :cascade do |t|
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "conversation_id"
    t.integer  "callable_id"
    t.string   "callable_type"
    t.integer  "post_id"
    t.boolean  "declined",        default: false
  end

  add_index "calls", ["callable_type", "callable_id"], name: "index_calls_on_callable_type_and_callable_id", using: :btree
  add_index "calls", ["conversation_id"], name: "index_calls_on_conversation_id", using: :btree
  add_index "calls", ["post_id"], name: "index_calls_on_post_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "creator_id"
  end

  add_index "conversations", ["creator_id"], name: "index_conversations_on_creator_id", using: :btree

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

  add_index "facebook_activations", ["facebook_id"], name: "index_facebook_activations_on_facebook_id", using: :btree
  add_index "facebook_activations", ["user_id"], name: "index_facebook_activations_on_user_id", using: :btree

  create_table "facebooks", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "facebooks", ["owner_type", "owner_id"], name: "index_facebooks_on_owner_type_and_owner_id", using: :btree

  create_table "object_actions", force: :cascade do |t|
    t.integer  "object_id"
    t.string   "object_type"
    t.string   "support"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "creator_id"
    t.string   "status"
  end

  add_index "object_actions", ["creator_id"], name: "index_object_actions_on_creator_id", using: :btree
  add_index "object_actions", ["object_type", "object_id"], name: "index_object_actions_on_object_type_and_object_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "conversation_id"
    t.text     "content"
    t.integer  "creator_id"
    t.boolean  "edited",          default: false
    t.string   "feeling",         default: "neutral"
  end

  add_index "posts", ["conversation_id"], name: "index_posts_on_conversation_id", using: :btree
  add_index "posts", ["creator_id"], name: "index_posts_on_creator_id", using: :btree

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

  add_index "twitters", ["owner_type", "owner_id"], name: "index_twitters_on_owner_type_and_owner_id", using: :btree

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

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "websites", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "websites", ["owner_type", "owner_id"], name: "index_websites_on_owner_type_and_owner_id", using: :btree

  add_foreign_key "calls", "conversations"
  add_foreign_key "calls", "posts"
  add_foreign_key "facebook_activations", "facebooks"
  add_foreign_key "facebook_activations", "users"
  add_foreign_key "posts", "conversations"
end
