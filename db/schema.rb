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

ActiveRecord::Schema.define(version: 20151009092041) do

  create_table "appointments", force: :cascade do |t|
    t.text     "body",               limit: 65535
    t.integer  "company_id",         limit: 4
    t.integer  "person_id",          limit: 4
    t.datetime "when"
    t.integer  "status",             limit: 4,     default: 0
    t.integer  "communication_type", limit: 4,     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",            limit: 4
    t.integer  "opportunity_id",     limit: 4
  end

  add_index "appointments", ["company_id"], name: "index_appointments_on_company_id", using: :btree
  add_index "appointments", ["opportunity_id"], name: "index_appointments_on_opportunity_id", using: :btree
  add_index "appointments", ["person_id"], name: "index_appointments_on_person_id", using: :btree
  add_index "appointments", ["user_id"], name: "index_appointments_on_user_id", using: :btree
  add_index "appointments", ["when"], name: "index_appointments_on_when", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "about",      limit: 65535
    t.string   "phone",      limit: 255
    t.string   "web",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ava",        limit: 255
    t.integer  "condition",  limit: 4,     default: 0
    t.integer  "user_id",    limit: 4
  end

  add_index "companies", ["condition"], name: "index_companies_on_condition", using: :btree
  add_index "companies", ["user_id"], name: "index_companies_on_user_id", using: :btree

  create_table "company_people", force: :cascade do |t|
    t.integer  "company_id", limit: 4
    t.integer  "person_id",  limit: 4
    t.string   "role",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "company_people", ["company_id"], name: "index_company_people_on_company_id", using: :btree
  add_index "company_people", ["person_id"], name: "index_company_people_on_person_id", using: :btree

  create_table "opportunities", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.date     "start"
    t.date     "finish"
    t.text     "description", limit: 65535
    t.integer  "stage",       limit: 4,                             default: 0
    t.integer  "status",      limit: 4,                             default: 0
    t.integer  "company_id",  limit: 4
    t.integer  "person_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount",                    precision: 8, scale: 2
    t.integer  "user_id",     limit: 4
  end

  add_index "opportunities", ["company_id"], name: "index_opportunities_on_company_id", using: :btree
  add_index "opportunities", ["person_id"], name: "index_opportunities_on_person_id", using: :btree
  add_index "opportunities", ["start"], name: "index_opportunities_on_start", using: :btree
  add_index "opportunities", ["user_id"], name: "index_opportunities_on_user_id", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "about",      limit: 65535
    t.string   "phone",      limit: 255
    t.string   "facebook",   limit: 255
    t.string   "twitter",    limit: 255
    t.string   "web",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ava",        limit: 255
    t.integer  "condition",  limit: 4,     default: 0
    t.integer  "user_id",    limit: 4
    t.string   "email",      limit: 255
  end

  add_index "people", ["condition"], name: "index_people_on_condition", using: :btree
  add_index "people", ["user_id"], name: "index_people_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.integer  "condition",              limit: 4,   default: 0
  end

  add_index "users", ["condition"], name: "index_users_on_condition", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "role_id", limit: 4
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
