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

ActiveRecord::Schema.define(version: 20160725153836) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "current_offences", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "offences_id",    null: false
    t.string   "offence"
    t.string   "case_reference"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

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
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "workflow_status", default: "not_started"
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
    t.string   "has_medications",          default: "unknown"
    t.string   "mpv",                      default: "unknown"
    t.text     "mpv_details"
    t.string   "healthcare_professional"
    t.string   "contact_number"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "workflow_status",          default: "not_started"
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
    t.text     "not_for_release_details"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "has_past_offences",       default: "unknown"
    t.string   "workflow_status",         default: "not_started"
  end

  create_table "past_offences", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "offences_id"
    t.string   "offence"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "risks", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "escort_id"
    t.string   "open_acct",                       default: "unknown"
    t.text     "open_acct_details"
    t.string   "suicide",                         default: "unknown"
    t.text     "suicide_details"
    t.string   "rule_45",                         default: "unknown"
    t.text     "rule_45_details"
    t.string   "csra",                            default: "unknown"
    t.text     "csra_details"
    t.string   "verbal_abuse",                    default: "unknown"
    t.text     "verbal_abuse_details"
    t.string   "physical_abuse",                  default: "unknown"
    t.text     "physical_abuse_details"
    t.string   "violent",                         default: "unknown"
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
    t.string   "stalker_harasser_bully",          default: "unknown"
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
    t.string   "sex_offence",                     default: "unknown"
    t.string   "sex_offence_victim"
    t.text     "sex_offence_details"
    t.string   "non_association_markers",         default: "unknown"
    t.text     "non_association_markers_details"
    t.string   "current_e_risk",                  default: "unknown"
    t.text     "current_e_risk_details"
    t.string   "escape_list",                     default: "unknown"
    t.text     "escape_list_details"
    t.string   "other_escape_risk_info",          default: "unknown"
    t.text     "other_escape_risk_info_details"
    t.string   "category_a",                      default: "unknown"
    t.text     "category_a_details"
    t.string   "restricted_status",               default: "unknown"
    t.text     "restricted_status_details"
    t.boolean  "escape_pack"
    t.boolean  "escape_risk_assessment"
    t.boolean  "cuffing_protocol"
    t.string   "drugs",                           default: "unknown"
    t.text     "drugs_details"
    t.string   "alcohol",                         default: "unknown"
    t.text     "alcohol_details"
    t.string   "conceals_weapons",                default: "unknown"
    t.text     "conceals_weapons_details"
    t.string   "arson",                           default: "unknown"
    t.text     "arson_details"
    t.string   "arson_value"
    t.string   "damage_to_property",              default: "unknown"
    t.text     "damage_to_property_details"
    t.string   "interpreter_required",            default: "unknown"
    t.text     "language"
    t.string   "hearing_speach_sight",            default: "unknown"
    t.text     "hearing_speach_sight_details"
    t.string   "can_read_and_write",              default: "unknown"
    t.text     "can_read_and_write_details"
    t.string   "workflow_status",                 default: "not_started"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
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
