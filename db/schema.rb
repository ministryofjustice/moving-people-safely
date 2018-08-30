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

ActiveRecord::Schema.define(version: 2018_08_22_073352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "audits", force: :cascade do |t|
    t.uuid "escort_id"
    t.integer "user_id"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "datafix_log", force: :cascade do |t|
    t.string "direction"
    t.string "script"
    t.datetime "timestamp"
  end

  create_table "detainees", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "forenames"
    t.string "surname"
    t.date "date_of_birth"
    t.string "gender"
    t.string "prison_number"
    t.text "nationalities"
    t.string "pnc_number"
    t.string "cro_number"
    t.text "aliases"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_filename", default: ""
    t.binary "image"
    t.uuid "escort_id"
    t.string "ethnicity"
    t.string "religion"
    t.string "language"
    t.string "interpreter_required"
    t.string "diet"
    t.string "peep"
    t.text "peep_details"
    t.text "interpreter_required_details"
    t.string "security_category"
    t.index ["escort_id"], name: "index_detainees_on_escort_id"
    t.index ["prison_number"], name: "index_detainees_on_prison_number"
  end

  create_table "escorts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "prison_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.datetime "issued_at"
    t.uuid "cloned_id"
    t.string "document_file_name"
    t.string "document_content_type"
    t.integer "document_file_size"
    t.datetime "document_updated_at"
    t.integer "canceller_id"
    t.datetime "cancelled_at"
    t.text "cancelling_reason"
    t.string "pnc_number"
    t.datetime "approved_at"
    t.integer "approver_id"
    t.index ["cloned_id"], name: "index_escorts_on_cloned_id"
    t.index ["deleted_at"], name: "index_escorts_on_deleted_at"
    t.index ["pnc_number"], name: "index_escorts_on_pnc_number"
    t.index ["prison_number"], name: "index_escorts_on_prison_number"
  end

  create_table "establishments", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.string "nomis_id"
    t.string "sso_id"
    t.string "healthcare_contact_number"
    t.string "end_date"
    t.index ["nomis_id"], name: "index_establishments_on_nomis_id", unique: true
    t.index ["sso_id"], name: "index_establishments_on_sso_id", unique: true
    t.index ["type"], name: "index_establishments_on_type"
  end

  create_table "healthcare", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "physical_issues"
    t.text "physical_issues_details"
    t.string "mental_illness"
    t.text "mental_illness_details"
    t.string "personal_care"
    t.text "personal_care_details"
    t.string "allergies"
    t.text "allergies_details"
    t.string "dependencies"
    t.text "dependencies_details"
    t.string "has_medications"
    t.string "mpv"
    t.text "mpv_details"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "escort_id"
    t.integer "status", default: 0
    t.integer "reviewer_id"
    t.datetime "reviewed_at"
    t.text "medications"
    t.string "pregnant"
    t.text "pregnant_details"
    t.string "alcohol_withdrawal"
    t.text "alcohol_withdrawal_details"
    t.string "female_hygiene_kit"
    t.text "female_hygiene_kit_details"
    t.index ["escort_id"], name: "index_healthcare_on_escort_id"
  end

  create_table "medications", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "healthcare_id"
    t.string "description"
    t.string "administration"
    t.string "dosage"
    t.string "when_given"
    t.string "carrier"
  end

  create_table "moves", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "to"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "not_for_release"
    t.string "not_for_release_reason"
    t.text "not_for_release_reason_details"
    t.uuid "escort_id"
    t.uuid "from_establishment_id"
    t.string "to_type"
    t.index ["escort_id"], name: "index_moves_on_escort_id"
  end

  create_table "must_not_return_details", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "risk_id"
    t.string "establishment"
    t.string "establishment_details"
  end

  create_table "offences", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "offence"
    t.string "case_reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "detainee_id"
    t.uuid "escort_id"
    t.index ["detainee_id"], name: "index_offences_on_detainee_id"
  end

  create_table "offences_workflows", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "status", default: 0
    t.datetime "reviewed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reviewer_id"
    t.uuid "escort_id"
    t.index ["escort_id"], name: "index_offences_workflows_on_escort_id"
  end

  create_table "risks", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "rule_45"
    t.string "csra"
    t.string "risk_to_females"
    t.text "risk_to_females_details"
    t.string "homophobic"
    t.text "homophobic_details"
    t.string "racist"
    t.text "racist_details"
    t.string "sex_offence"
    t.string "current_e_risk"
    t.text "current_e_risk_details"
    t.string "category_a"
    t.string "substance_supply"
    t.string "conceals_weapons"
    t.text "conceals_weapons_details"
    t.string "arson"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "acct_status"
    t.text "acct_status_details"
    t.date "date_of_most_recently_closed_acct"
    t.string "high_profile"
    t.text "high_profile_details"
    t.string "other_violence_due_to_discrimination"
    t.text "other_violence_due_to_discrimination_details"
    t.string "violence_to_staff"
    t.string "gang_member"
    t.text "gang_member_details"
    t.string "hostage_taker"
    t.string "previous_escape_attempts"
    t.boolean "prison_escape_attempt"
    t.text "prison_escape_attempt_details"
    t.boolean "court_escape_attempt"
    t.text "court_escape_attempt_details"
    t.boolean "police_escape_attempt"
    t.text "police_escape_attempt_details"
    t.boolean "other_type_escape_attempt"
    t.text "other_type_escape_attempt_details"
    t.string "escort_risk_assessment"
    t.string "escape_pack"
    t.string "conceals_drugs"
    t.text "conceals_drugs_details"
    t.text "conceals_mobile_phone_or_other_items"
    t.string "controlled_unlock"
    t.text "controlled_unlock_details"
    t.string "other_risk"
    t.text "other_risk_details"
    t.uuid "escort_id"
    t.string "uses_weapons"
    t.text "uses_weapons_details"
    t.string "discrimination_to_other_religions"
    t.text "discrimination_to_other_religions_details"
    t.text "violence_to_staff_details"
    t.integer "status", default: 0
    t.integer "reviewer_id"
    t.datetime "reviewed_at"
    t.string "must_return"
    t.string "must_return_to"
    t.text "must_return_to_details"
    t.string "has_must_not_return_details"
    t.text "must_not_return_details"
    t.text "previous_escape_attempts_details"
    t.string "self_harm"
    t.text "self_harm_details"
    t.string "vulnerable_prisoner"
    t.text "vulnerable_prisoner_details"
    t.string "pnc_warnings"
    t.text "pnc_warnings_details"
    t.string "intimidation_prisoners"
    t.text "intimidation_prisoners_details"
    t.string "intimidation_public"
    t.text "intimidation_public_details"
    t.text "hostage_taker_details"
    t.text "sex_offence_details"
    t.text "conceals_mobile_phone_or_other_items_details"
    t.string "violent_or_dangerous"
    t.text "violent_or_dangerous_details"
    t.text "csra_details"
    t.text "substance_supply_details"
    t.index ["escort_id"], name: "index_risks_on_escort_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.text "permissions"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
