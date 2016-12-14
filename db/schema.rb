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

ActiveRecord::Schema.define(version: 20161213112217) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "current_offences", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "offences_id"
    t.string   "offence"
    t.string   "case_reference"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["offences_id"], name: "index_current_offences_on_offences_id", using: :btree
  end

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
    t.index ["prison_number"], name: "index_detainees_on_prison_number", using: :btree
  end

  create_table "healthcare", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.string   "has_medications",          default: "unknown"
    t.string   "mpv",                      default: "unknown"
    t.text     "mpv_details"
    t.string   "healthcare_professional"
    t.string   "contact_number"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.uuid     "detainee_id"
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
    t.string   "reason"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "has_destinations", default: "unknown"
    t.text     "reason_details"
    t.uuid     "detainee_id"
    t.index ["detainee_id"], name: "index_moves_on_detainee_id", using: :btree
  end

  create_table "offences", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.date     "release_date"
    t.boolean  "not_for_release"
    t.text     "not_for_release_details"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "has_past_offences",       default: "unknown"
    t.uuid     "detainee_id"
    t.index ["detainee_id"], name: "index_offences_on_detainee_id", using: :btree
  end

  create_table "past_offences", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "offences_id"
    t.string   "offence"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["offences_id"], name: "index_past_offences_on_offences_id", using: :btree
  end

  create_table "risks", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "rule_45",                                      default: "unknown"
    t.string   "csra",                                         default: "unknown"
    t.string   "violent",                                      default: "unknown"
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
    t.string   "stalker_harasser_bully",                       default: "unknown"
    t.boolean  "hostage_taker"
    t.text     "hostage_taker_details"
    t.boolean  "stalker"
    t.text     "stalker_details"
    t.boolean  "harasser"
    t.text     "harasser_details"
    t.boolean  "intimidator"
    t.text     "intimidator_details"
    t.boolean  "bully"
    t.text     "bully_details"
    t.string   "sex_offence",                                  default: "unknown"
    t.string   "sex_offence_victim"
    t.text     "sex_offence_details"
    t.string   "non_association_markers",                      default: "unknown"
    t.text     "non_association_markers_details"
    t.string   "current_e_risk",                               default: "unknown"
    t.text     "current_e_risk_details"
    t.string   "category_a",                                   default: "unknown"
    t.text     "category_a_details"
    t.string   "restricted_status",                            default: "unknown"
    t.text     "restricted_status_details"
    t.boolean  "escape_pack"
    t.boolean  "escape_risk_assessment"
    t.boolean  "cuffing_protocol"
    t.string   "substance_supply",                             default: "unknown"
    t.text     "substance_supply_details"
    t.string   "substance_use",                                default: "unknown"
    t.text     "substance_use_details"
    t.string   "conceals_weapons",                             default: "unknown"
    t.text     "conceals_weapons_details"
    t.string   "arson",                                        default: "unknown"
    t.text     "arson_details"
    t.string   "arson_value"
    t.string   "damage_to_property",                           default: "unknown"
    t.text     "damage_to_property_details"
    t.string   "interpreter_required",                         default: "unknown"
    t.text     "language"
    t.string   "hearing_speach_sight",                         default: "unknown"
    t.text     "hearing_speach_sight_details"
    t.string   "can_read_and_write",                           default: "unknown"
    t.text     "can_read_and_write_details"
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
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
    t.string   "provider"
    t.string   "uid"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
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
