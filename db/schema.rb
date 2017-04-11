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

ActiveRecord::Schema.define(version: 20170410095345) do

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
    t.index ["move_id"], name: "index_destinations_on_move_id", using: :btree
  end

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
    t.index ["prison_number"], name: "index_detainees_on_prison_number", using: :btree
  end

  create_table "healthcare", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "physical_issues",                     default: "unknown"
    t.text     "physical_issues_details"
    t.string   "mental_illness",                      default: "unknown"
    t.text     "mental_illness_details"
    t.string   "phobias",                             default: "unknown"
    t.text     "phobias_details"
    t.string   "personal_hygiene",                    default: "unknown"
    t.text     "personal_hygiene_details"
    t.string   "personal_care",                       default: "unknown"
    t.text     "personal_care_details"
    t.string   "allergies",                           default: "unknown"
    t.text     "allergies_details"
    t.string   "dependencies",                        default: "unknown"
    t.text     "dependencies_details"
    t.string   "has_medications",                     default: "unknown"
    t.string   "mpv",                                 default: "unknown"
    t.text     "mpv_details"
    t.string   "healthcare_professional"
    t.string   "contact_number"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.uuid     "detainee_id"
    t.string   "hearing_speech_sight_issues"
    t.text     "hearing_speech_sight_issues_details"
    t.string   "reading_writing_issues"
    t.text     "reading_writing_issues_details"
    t.index ["detainee_id"], name: "index_healthcare_on_detainee_id", using: :btree
  end

  create_table "medications", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "healthcare_id"
    t.string   "description"
    t.string   "administration"
    t.string   "carrier"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["healthcare_id"], name: "index_medications_on_healthcare_id", using: :btree
  end

  create_table "moves", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "from"
    t.string   "to"
    t.date     "date"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "has_destinations",               default: "unknown"
    t.uuid     "detainee_id"
    t.string   "not_for_release"
    t.string   "not_for_release_reason"
    t.text     "not_for_release_reason_details"
    t.index ["detainee_id"], name: "index_moves_on_detainee_id", using: :btree
  end

  create_table "offences", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "offence"
    t.string   "case_reference"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.uuid     "detainee_id"
    t.index ["detainee_id"], name: "index_offences_on_detainee_id", using: :btree
  end

  create_table "risks", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "rule_45",                                           default: "unknown"
    t.string   "csra",                                              default: "unknown"
    t.string   "violent",                                           default: "unknown"
    t.boolean  "prison_staff"
    t.text     "prison_staff_details"
    t.boolean  "risk_to_females"
    t.text     "risk_to_females_details"
    t.boolean  "escort_or_court_staff"
    t.text     "escort_or_court_staff_details"
    t.boolean  "healthcare_staff"
    t.text     "healthcare_staff_details"
    t.boolean  "other_detainees"
    t.text     "other_detainees_details"
    t.boolean  "homophobic"
    t.text     "homophobic_details"
    t.boolean  "racist"
    t.text     "racist_details"
    t.boolean  "public_offence_related"
    t.text     "public_offence_related_details"
    t.boolean  "police"
    t.text     "police_details"
    t.string   "stalker_harasser_bully",                            default: "unknown"
    t.boolean  "harasser"
    t.text     "harasser_details"
    t.boolean  "intimidator"
    t.text     "intimidator_details"
    t.boolean  "bully"
    t.text     "bully_details"
    t.string   "sex_offence",                                       default: "unknown"
    t.string   "current_e_risk",                                    default: "unknown"
    t.text     "current_e_risk_details"
    t.string   "category_a",                                        default: "unknown"
    t.text     "category_a_details"
    t.string   "substance_supply",                                  default: "unknown"
    t.string   "conceals_weapons",                                  default: "unknown"
    t.text     "conceals_weapons_details"
    t.string   "arson",                                             default: "unknown"
    t.string   "damage_to_property",                                default: "unknown"
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.uuid     "detainee_id"
    t.string   "acct_status"
    t.text     "acct_status_details"
    t.date     "date_of_most_recently_closed_acct"
    t.string   "victim_of_abuse"
    t.text     "victim_of_abuse_details"
    t.string   "high_profile"
    t.text     "high_profile_details"
    t.string   "violence_due_to_discrimination"
    t.boolean  "other_violence_due_to_discrimination"
    t.text     "other_violence_due_to_discrimination_details"
    t.string   "violence_to_staff"
    t.boolean  "violence_to_staff_custody"
    t.boolean  "violence_to_staff_community"
    t.string   "violence_to_other_detainees"
    t.boolean  "co_defendant"
    t.text     "co_defendant_details"
    t.boolean  "gang_member"
    t.text     "gang_member_details"
    t.boolean  "other_violence_to_other_detainees"
    t.text     "other_violence_to_other_detainees_details"
    t.string   "violence_to_general_public"
    t.text     "violence_to_general_public_details"
    t.string   "harassment"
    t.text     "harassment_details"
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
    t.text     "sex_offence_under18_victim_details"
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
    t.date     "escort_risk_assessment_completion_date"
    t.string   "escape_pack"
    t.date     "escape_pack_completion_date"
    t.string   "conceals_drugs"
    t.text     "conceals_drugs_details"
    t.text     "conceals_mobile_phone_or_other_items"
    t.boolean  "conceals_mobile_phones"
    t.boolean  "conceals_sim_cards"
    t.boolean  "conceals_other_items"
    t.text     "conceals_other_items_details"
    t.boolean  "trafficking_drugs"
    t.boolean  "trafficking_alcohol"
    t.index ["detainee_id"], name: "index_risks_on_detainee_id", using: :btree
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

  create_table "workflows", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "move_id"
    t.string   "type",                    null: false
    t.integer  "status",      default: 0
    t.datetime "reviewed_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "reviewer_id"
    t.index ["move_id"], name: "index_workflows_on_move_id", using: :btree
    t.index ["type"], name: "index_workflows_on_type", using: :btree
  end

end
