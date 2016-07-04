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

ActiveRecord::Schema.define(version: 20160704125939) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "destinations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "move_id"
    t.string   "establishment"
    t.string   "must_return",   default: "unknown"
    t.text     "reasons"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "detainees", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "escort_id"
    t.string   "forenames"
    t.string   "surname"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "prison_number"
    t.text     "nationalities"
    t.string   "pnc_number"
    t.string   "cro_number"
    t.text     "aliases"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "escorts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "healthcare", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "escort_id"
    t.string   "physical_issues",          default: "unknown"
    t.text     "physical_issues_details"
    t.string   "mental_illness",           default: "unknown"
    t.text     "mental_illness_details"
    t.string   "phobias",                  default: "unknown"
    t.text     "phobias_details"
    t.string   "personal_hygiene",         default: "unknown"
    t.text     "personal_hygiene_details"
    t.string   "personal_care",            default: "unknown"
    t.text     "personal_care_details"
    t.string   "allergies",                default: "unknown"
    t.text     "allergies_details"
    t.string   "dependencies",             default: "unknown"
    t.text     "dependencies_details"
    t.string   "medication",               default: "unknown"
    t.string   "mpv",                      default: "unknown"
    t.text     "mpv_details"
    t.string   "healthcare_professional"
    t.string   "contact_number"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "medications", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "healthcare_id"
    t.string   "description"
    t.string   "administration"
    t.string   "carrier"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "moves", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "escort_id"
    t.string   "from"
    t.string   "to"
    t.date     "date"
    t.string   "reason"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "has_destinations", default: "unknown"
    t.text     "reason_details"
  end

  create_table "offences", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "escort_id"
    t.date     "release_date"
    t.boolean  "not_for_release"
    t.text     "not_for_release_reason"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "risks", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid   "escort_id"
    t.string "open_acct",              default: "unknown"
    t.text   "open_acct_details"
    t.string "suicide",                default: "unknown"
    t.text   "suicide_details"
    t.string "rule_45",                default: "unknown"
    t.text   "rule_45_details"
    t.string "csra",                   default: "unknown"
    t.text   "csra_details"
    t.string "verbal_abuse",           default: "unknown"
    t.text   "verbal_abuse_details"
    t.string "physical_abuse",         default: "unknown"
    t.text   "physical_abuse_details"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
