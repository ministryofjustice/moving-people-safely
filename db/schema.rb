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

ActiveRecord::Schema.define(version: 20170721132806) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "detainees", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "forenames"
    t.string   "surname"
    t.date     "date_of_birth"
    t.string   "gender"
    t.string   "prison_number"
    t.text     "nationalities"
    t.string   "pnc_number"
    t.string   "cro_number"
    t.text     "aliases"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "image_filename", default: ""
    t.binary   "image"
    t.uuid     "escort_id"
    t.index ["escort_id"], name: "index_detainees_on_escort_id", using: :btree
    t.index ["prison_number"], name: "index_detainees_on_prison_number", using: :btree
  end

  create_table "escorts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "prison_number"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.datetime "deleted_at"
    t.datetime "issued_at"
    t.uuid     "cloned_id"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.integer  "canceller_id"
    t.datetime "cancelled_at"
    t.text     "cancelling_reason"
    t.index ["cloned_id"], name: "index_escorts_on_cloned_id", using: :btree
    t.index ["deleted_at"], name: "index_escorts_on_deleted_at", using: :btree
    t.index ["prison_number"], name: "index_escorts_on_prison_number", using: :btree
  end

  create_table "healthcare", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "physical_issues"
    t.text     "physical_issues_details"
    t.string   "mental_illness"
    t.text     "mental_illness_details"
    t.string   "personal_care"
    t.text     "personal_care_details"
    t.string   "allergies"
    t.text     "allergies_details"
    t.string   "dependencies"
    t.text     "dependencies_details"
    t.string   "has_medications"
    t.string   "mpv"
    t.text     "mpv_details"
    t.string   "contact_number"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.uuid     "escort_id"
    t.integer  "status",                  default: 0
    t.integer  "reviewer_id"
    t.datetime "reviewed_at"
    t.text     "medications"
    t.index ["escort_id"], name: "index_healthcare_on_escort_id", using: :btree
  end

  create_table "moves", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "from"
    t.string   "to"
    t.date     "date"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "not_for_release"
    t.string   "not_for_release_reason"
    t.text     "not_for_release_reason_details"
    t.uuid     "escort_id"
    t.index ["escort_id"], name: "index_moves_on_escort_id", using: :btree
  end

  create_table "offences", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "offence"
    t.string   "case_reference"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.uuid     "detainee_id"
    t.index ["detainee_id"], name: "index_offences_on_detainee_id", using: :btree
  end

  create_table "offences_workflows", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "detainee_id"
    t.integer  "status",      default: 0
    t.datetime "reviewed_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "reviewer_id"
    t.index ["detainee_id"], name: "index_offences_workflows_on_detainee_id", using: :btree
  end

  create_table "risks", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "rule_45"
    t.string   "csra"
    t.string   "risk_to_females"
    t.text     "risk_to_females_details"
    t.string   "homophobic"
    t.text     "homophobic_details"
    t.string   "racist"
    t.text     "racist_details"
    t.string   "sex_offence"
    t.string   "current_e_risk"
    t.text     "current_e_risk_details"
    t.string   "category_a"
    t.string   "substance_supply"
    t.string   "conceals_weapons"
    t.text     "conceals_weapons_details"
    t.string   "arson"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.string   "acct_status"
    t.text     "acct_status_details"
    t.date     "date_of_most_recently_closed_acct"
    t.string   "high_profile"
    t.text     "high_profile_details"
    t.string   "other_violence_due_to_discrimination"
    t.text     "other_violence_due_to_discrimination_details"
    t.string   "violence_to_staff"
    t.string   "violence_to_other_detainees"
    t.boolean  "co_defendant"
    t.text     "co_defendant_details"
    t.boolean  "gang_member"
    t.text     "gang_member_details"
    t.boolean  "other_violence_to_other_detainees"
    t.text     "other_violence_to_other_detainees_details"
    t.string   "violence_to_general_public"
    t.text     "violence_to_general_public_details"
    t.text     "intimidation"
    t.boolean  "intimidation_to_staff"
    t.text     "intimidation_to_staff_details"
    t.boolean  "intimidation_to_public"
    t.text     "intimidation_to_public_details"
    t.boolean  "intimidation_to_other_detainees"
    t.text     "intimidation_to_other_detainees_details"
    t.boolean  "intimidation_to_witnesses"
    t.text     "intimidation_to_witnesses_details"
    t.string   "hostage_taker"
    t.boolean  "staff_hostage_taker"
    t.date     "date_most_recent_staff_hostage_taker_incident"
    t.boolean  "prisoners_hostage_taker"
    t.date     "date_most_recent_prisoners_hostage_taker_incident"
    t.boolean  "public_hostage_taker"
    t.date     "date_most_recent_public_hostage_taker_incident"
    t.boolean  "sex_offence_adult_male_victim"
    t.boolean  "sex_offence_adult_female_victim"
    t.boolean  "sex_offence_under18_victim"
    t.string   "previous_escape_attempts"
    t.boolean  "prison_escape_attempt"
    t.text     "prison_escape_attempt_details"
    t.boolean  "court_escape_attempt"
    t.text     "court_escape_attempt_details"
    t.boolean  "police_escape_attempt"
    t.text     "police_escape_attempt_details"
    t.boolean  "other_type_escape_attempt"
    t.text     "other_type_escape_attempt_details"
    t.string   "escort_risk_assessment"
    t.string   "escape_pack"
    t.string   "conceals_drugs"
    t.text     "conceals_drugs_details"
    t.text     "conceals_mobile_phone_or_other_items"
    t.boolean  "conceals_mobile_phones"
    t.boolean  "conceals_sim_cards"
    t.boolean  "conceals_other_items"
    t.text     "conceals_other_items_details"
    t.string   "controlled_unlock_required"
    t.string   "controlled_unlock"
    t.text     "controlled_unlock_details"
    t.string   "other_risk"
    t.text     "other_risk_details"
    t.uuid     "escort_id"
    t.string   "uses_weapons"
    t.text     "uses_weapons_details"
    t.string   "discrimination_to_other_religions"
    t.text     "discrimination_to_other_religions_details"
    t.text     "violence_to_staff_details"
    t.date     "date_most_recent_sexual_offence"
    t.integer  "status",                                            default: 0
    t.integer  "reviewer_id"
    t.datetime "reviewed_at"
    t.string   "must_return"
    t.string   "must_return_to"
    t.text     "must_return_to_details"
    t.string   "must_not_return"
    t.text     "must_not_return_details"
    t.index ["escort_id"], name: "index_risks_on_escort_id", using: :btree
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",      default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "provider"
    t.string   "uid"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

end
