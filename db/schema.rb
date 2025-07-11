# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_07_11_154836) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ballot_items", force: :cascade do |t|
    t.bigint "ballot_id", null: false
    t.bigint "candidate_id", null: false
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ballot_id"], name: "index_ballot_items_on_ballot_id"
    t.index ["candidate_id"], name: "index_ballot_items_on_candidate_id"
  end

  create_table "ballots", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "election_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "delegated"
    t.string "delegation_chain"
    t.index ["election_id"], name: "index_ballots_on_election_id"
    t.index ["user_id"], name: "index_ballots_on_user_id"
  end

  create_table "candidates", force: :cascade do |t|
    t.string "name"
    t.bigint "election_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["election_id"], name: "index_candidates_on_election_id"
  end

  create_table "elections", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.boolean "phone_verified"
    t.string "verification_code"
    t.datetime "verification_sent_at"
    t.boolean "is_admin"
    t.bigint "delegate_id"
    t.index ["delegate_id"], name: "index_users_on_delegate_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "verification_attempts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "phone"
    t.string "code"
    t.boolean "success"
    t.string "ip_address"
    t.text "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_verification_attempts_on_user_id"
  end

  add_foreign_key "ballot_items", "ballots"
  add_foreign_key "ballot_items", "candidates"
  add_foreign_key "ballots", "elections"
  add_foreign_key "ballots", "users"
  add_foreign_key "candidates", "elections"
  add_foreign_key "users", "users", column: "delegate_id"
  add_foreign_key "verification_attempts", "users"
end
