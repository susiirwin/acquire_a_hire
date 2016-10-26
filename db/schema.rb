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

ActiveRecord::Schema.define(version: 20161026003828) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "jobs", force: :cascade do |t|
    t.string   "title"
    t.integer  "skill_id"
    t.integer  "min_price"
    t.integer  "max_price"
    t.integer  "requester_id"
    t.string   "status",          default: "available"
    t.string   "description"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "state"
    t.integer  "professional_id"
    t.index ["professional_id"], name: "index_jobs_on_professional_id", using: :btree
    t.index ["requester_id"], name: "index_jobs_on_requester_id", using: :btree
    t.index ["skill_id"], name: "index_jobs_on_skill_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.string   "body"
    t.text     "subject"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "job_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "attachment"
    t.index ["job_id"], name: "index_messages_on_job_id", using: :btree
    t.index ["recipient_id"], name: "index_messages_on_recipient_id", using: :btree
    t.index ["sender_id"], name: "index_messages_on_sender_id", using: :btree
  end

  create_table "reviews", force: :cascade do |t|
    t.text     "review"
    t.integer  "professional_id", null: false
    t.integer  "requester_id",    null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "reviewee_role"
    t.integer  "rating"
  end

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_apis", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.text     "description"
    t.string   "url"
    t.string   "key"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "redirect_url"
    t.integer  "user_id"
    t.string   "secret"
    t.string   "app_name"
    t.index ["user_id"], name: "index_user_apis_on_user_id", using: :btree
  end

  create_table "user_authorizations", force: :cascade do |t|
    t.string  "code"
    t.integer "user_id"
    t.integer "user_api_id"
    t.boolean "authorized",  default: false
    t.string  "token"
    t.index ["user_api_id"], name: "index_user_authorizations_on_user_api_id", using: :btree
    t.index ["user_id"], name: "index_user_authorizations_on_user_id", using: :btree
  end

  create_table "user_skills", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_user_skills_on_skill_id", using: :btree
    t.index ["user_id"], name: "index_user_skills_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "password_digest"
    t.string   "password_confirmation"
    t.string   "business_name"
    t.string   "authy_id"
    t.boolean  "verified",              default: false
    t.integer  "role"
    t.string   "api_key"
  end

  add_foreign_key "jobs", "skills"
  add_foreign_key "jobs", "users", column: "professional_id"
  add_foreign_key "jobs", "users", column: "requester_id"
  add_foreign_key "messages", "jobs"
  add_foreign_key "messages", "users", column: "recipient_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "reviews", "users", column: "professional_id"
  add_foreign_key "reviews", "users", column: "requester_id"
  add_foreign_key "user_apis", "users"
  add_foreign_key "user_authorizations", "user_apis"
  add_foreign_key "user_authorizations", "users"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
end
