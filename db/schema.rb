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

ActiveRecord::Schema.define(version: 20180821162218) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "activity_type"
    t.string "name"
  end

  create_table "availabilities", force: :cascade do |t|
    t.integer  "community_id"
    t.string   "capacity_type"
    t.integer  "number_available"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["community_id"], name: "index_availabilities_on_community_id", using: :btree
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.integer  "county_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_cities_on_county_id", using: :btree
  end

  create_table "communities", force: :cascade do |t|
    t.string   "account_number"
    t.integer  "company_id"
    t.integer  "executive_director_id"
    t.integer  "nursing_director_id"
    t.string   "name"
    t.string   "address_1"
    t.string   "address_2"
    t.float    "latitude"
    t.float    "longitude"
    t.date     "open_since"
    t.integer  "semi_private_capacity"
    t.integer  "private_capacity"
    t.boolean  "pets"
    t.integer  "pharmacy_id"
    t.boolean  "transport"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "user_id"
    t.integer  "zip_code_id"
    t.integer  "semi_private_cents",           default: 0,     null: false
    t.string   "semi_private_currency",        default: "USD", null: false
    t.integer  "private_cents",                default: 0,     null: false
    t.string   "private_currency",             default: "USD", null: false
    t.integer  "community_fee_cents",          default: 0,     null: false
    t.string   "community_fee_currency",       default: "USD", null: false
    t.integer  "respite_rate_cents",           default: 0,     null: false
    t.string   "respite_rate_currency",        default: "USD", null: false
    t.integer  "adult_day_care_rate_cents",    default: 0,     null: false
    t.string   "adult_day_care_rate_currency", default: "USD", null: false
    t.string   "phone_number"
    t.string   "fax"
    t.string   "al_license"
    t.string   "website"
    t.integer  "admissions_director_id"
    t.float    "average_age"
    t.integer  "pet_fee_cents",                default: 0,     null: false
    t.string   "pet_fee_currency",             default: "USD", null: false
    t.integer  "marketing_director_id"
    t.boolean  "spanish",                      default: false
    t.integer  "second_person_fee_cents",      default: 0,     null: false
    t.string   "second_person_fee_currency",   default: "USD", null: false
    t.index ["company_id"], name: "index_communities_on_company_id", using: :btree
    t.index ["executive_director_id"], name: "index_communities_on_executive_director_id", using: :btree
    t.index ["nursing_director_id"], name: "index_communities_on_nursing_director_id", using: :btree
    t.index ["pharmacy_id"], name: "index_communities_on_pharmacy_id", using: :btree
    t.index ["user_id"], name: "index_communities_on_user_id", using: :btree
    t.index ["zip_code_id"], name: "index_communities_on_zip_code_id", using: :btree
  end

  create_table "community_activities", force: :cascade do |t|
    t.integer "activities_id"
    t.integer "community_id"
    t.index ["activities_id"], name: "index_community_activities_on_activities_id", using: :btree
    t.index ["community_id"], name: "index_community_activities_on_community_id", using: :btree
  end

  create_table "community_clinicians", force: :cascade do |t|
    t.integer "community_id"
    t.integer "contact_id"
    t.index ["community_id"], name: "index_community_clinicians_on_community_id", using: :btree
    t.index ["contact_id", "community_id"], name: "clinicians_index", unique: true, using: :btree
    t.index ["contact_id"], name: "index_community_clinicians_on_contact_id", using: :btree
  end

  create_table "community_dinings", force: :cascade do |t|
    t.integer "dinings_id"
    t.integer "community_id"
    t.index ["community_id"], name: "index_community_dinings_on_community_id", using: :btree
    t.index ["dinings_id"], name: "index_community_dinings_on_dinings_id", using: :btree
  end

  create_table "community_features", force: :cascade do |t|
    t.integer "features_id"
    t.integer "community_id"
    t.index ["community_id"], name: "index_community_features_on_community_id", using: :btree
    t.index ["features_id"], name: "index_community_features_on_features_id", using: :btree
  end

  create_table "community_license_types", force: :cascade do |t|
    t.integer "license_type_id"
    t.integer "community_id"
    t.index ["community_id"], name: "index_community_license_types_on_community_id", using: :btree
    t.index ["license_type_id", "community_id"], name: "licenses_index", unique: true, using: :btree
    t.index ["license_type_id"], name: "index_community_license_types_on_license_type_id", using: :btree
  end

  create_table "community_medicaid_providers", force: :cascade do |t|
    t.integer  "medicaid_provider_id"
    t.integer  "community_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["community_id"], name: "index_community_medicaid_providers_on_community_id", using: :btree
    t.index ["medicaid_provider_id"], name: "index_community_medicaid_providers_on_medicaid_provider_id", using: :btree
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "phone_number"
    t.string   "fax"
    t.string   "website"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "zip_code_id"
    t.integer  "communities_count", default: 0, null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_companies_on_user_id", using: :btree
    t.index ["zip_code_id"], name: "index_companies_on_zip_code_id", using: :btree
  end

  create_table "contact_results", force: :cascade do |t|
    t.integer  "result_id"
    t.integer  "contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_contact_results_on_contact_id", using: :btree
    t.index ["result_id"], name: "index_contact_results_on_result_id", using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "salutation"
    t.string   "gender"
    t.string   "email"
    t.string   "work_email"
    t.string   "home_phone"
    t.string   "cell_phone"
    t.string   "ssn_digest"
    t.string   "encrypted_ssn"
    t.string   "encrypted_ssn_iv"
    t.date     "dob"
    t.string   "address_1"
    t.string   "address_2"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "position_id"
    t.integer  "community_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "user_id"
    t.string   "work_phone"
    t.integer  "placement_status_id"
    t.integer  "facility_id"
    t.boolean  "veteran"
    t.date     "pay_entry_base_date"
    t.date     "end_of_active_service"
    t.date     "va_application_submitted"
    t.date     "benefit_received"
    t.date     "placement"
    t.boolean  "medicaid"
    t.boolean  "medicaid_icp"
    t.boolean  "medicaid_ltmc"
    t.boolean  "deceased",                 default: false
    t.text     "personal_history"
    t.text     "clinical_history"
    t.integer  "company_id"
    t.integer  "zip_code_id"
    t.string   "contact_type"
    t.string   "case_id"
    t.integer  "referrer_id"
    t.string   "phone_code"
    t.boolean  "validated"
    t.integer  "medicaid_provider_id"
    t.boolean  "spanish",                  default: false
    t.boolean  "web_lead",                 default: false
    t.index ["case_id"], name: "index_contacts_on_case_id", unique: true, using: :btree
    t.index ["community_id"], name: "index_contacts_on_community_id", using: :btree
    t.index ["company_id"], name: "index_contacts_on_company_id", using: :btree
    t.index ["facility_id"], name: "index_contacts_on_facility_id", using: :btree
    t.index ["medicaid_provider_id"], name: "index_contacts_on_medicaid_provider_id", using: :btree
    t.index ["placement_status_id"], name: "index_contacts_on_placement_status_id", using: :btree
    t.index ["position_id"], name: "index_contacts_on_position_id", using: :btree
    t.index ["ssn_digest"], name: "index_contacts_on_ssn_digest", unique: true, using: :btree
    t.index ["user_id"], name: "index_contacts_on_user_id", using: :btree
    t.index ["zip_code_id"], name: "index_contacts_on_zip_code_id", using: :btree
  end

  create_table "counties", force: :cascade do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_counties_on_state_id", using: :btree
  end

  create_table "data_files", force: :cascade do |t|
    t.string   "name"
    t.string   "storage"
    t.string   "fileable_type"
    t.integer  "fileable_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
    t.string   "file_data"
    t.index ["fileable_type", "fileable_id"], name: "index_data_files_on_fileable_type_and_fileable_id", using: :btree
    t.index ["user_id"], name: "index_data_files_on_user_id", using: :btree
  end

  create_table "decision_makers", force: :cascade do |t|
    t.integer "contact_id"
    t.integer "relationship_id"
    t.integer "hierarchy"
    t.index ["contact_id", "hierarchy"], name: "unique_dm_hierarchies", unique: true, using: :btree
    t.index ["contact_id", "relationship_id"], name: "unique_dm_relationships", unique: true, using: :btree
    t.index ["contact_id"], name: "index_decision_makers_on_contact_id", using: :btree
    t.index ["relationship_id"], name: "index_decision_makers_on_relationship_id", using: :btree
  end

  create_table "dinings", force: :cascade do |t|
    t.string "dining_type"
  end

  create_table "features", force: :cascade do |t|
    t.string "feature_type"
    t.string "name"
  end

  create_table "finances", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "checking_cents",               default: 0,     null: false
    t.string   "checking_currency",            default: "USD", null: false
    t.integer  "savings_cents",                default: 0,     null: false
    t.string   "savings_currency",             default: "USD", null: false
    t.integer  "money_market_cents",           default: 0,     null: false
    t.string   "money_market_currency",        default: "USD", null: false
    t.integer  "life_insurance_cents",         default: 0,     null: false
    t.string   "life_insurance_currency",      default: "USD", null: false
    t.integer  "veterans_aid_cents",           default: 0,     null: false
    t.string   "veterans_aid_currency",        default: "USD", null: false
    t.integer  "health_savings_cents",         default: 0,     null: false
    t.string   "health_savings_currency",      default: "USD", null: false
    t.integer  "other_cash_cents",             default: 0,     null: false
    t.string   "other_cash_currency",          default: "USD", null: false
    t.integer  "securities_cents",             default: 0,     null: false
    t.string   "securities_currency",          default: "USD", null: false
    t.integer  "treasury_bills_cents",         default: 0,     null: false
    t.string   "treasury_bills_currency",      default: "USD", null: false
    t.integer  "other_investments_cents",      default: 0,     null: false
    t.string   "other_investments_currency",   default: "USD", null: false
    t.integer  "retirement_accounts_cents",    default: 0,     null: false
    t.string   "retirement_accounts_currency", default: "USD", null: false
    t.integer  "pension_annuity_cents",        default: 0,     null: false
    t.string   "pension_annuity_currency",     default: "USD", null: false
    t.integer  "social_security_cents",        default: 0,     null: false
    t.string   "social_security_currency",     default: "USD", null: false
    t.integer  "other_retirement_cents",       default: 0,     null: false
    t.string   "other_retirement_currency",    default: "USD", null: false
    t.integer  "real_estate_cents",            default: 0,     null: false
    t.string   "real_estate_currency",         default: "USD", null: false
    t.integer  "automobile_cents",             default: 0,     null: false
    t.string   "automobile_currency",          default: "USD", null: false
    t.integer  "other_property_cents",         default: 0,     null: false
    t.string   "other_property_currency",      default: "USD", null: false
    t.integer  "notes_receivable_cents",       default: 0,     null: false
    t.string   "notes_receivable_currency",    default: "USD", null: false
    t.integer  "accounts_payable_cents",       default: 0,     null: false
    t.string   "accounts_payable_currency",    default: "USD", null: false
    t.integer  "auto_loan_cents",              default: 0,     null: false
    t.string   "auto_loan_currency",           default: "USD", null: false
    t.integer  "credit_card_debt_cents",       default: 0,     null: false
    t.string   "credit_card_debt_currency",    default: "USD", null: false
    t.integer  "mortgage_cents",               default: 0,     null: false
    t.string   "mortgage_currency",            default: "USD", null: false
    t.integer  "other_liabilities_cents",      default: 0,     null: false
    t.string   "other_liabilities_currency",   default: "USD", null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "medicaid_cents",               default: 0,     null: false
    t.string   "medicaid_currency",            default: "USD", null: false
    t.index ["contact_id"], name: "index_finances_on_contact_id", using: :btree
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "patient_id"
    t.integer  "company_id"
    t.integer  "amount_cents"
    t.date     "due_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["company_id"], name: "index_invoices_on_company_id", using: :btree
    t.index ["patient_id"], name: "index_invoices_on_patient_id", using: :btree
  end

  create_table "license_types", force: :cascade do |t|
    t.string "name"
  end

  create_table "medicaid_providers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.text     "content"
    t.string   "notable_type"
    t.integer  "notable_id"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["notable_type", "notable_id"], name: "index_notes_on_notable_type_and_notable_id", using: :btree
    t.index ["user_id"], name: "index_notes_on_user_id", using: :btree
  end

  create_table "patients", force: :cascade do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "salutation"
    t.string   "gender"
    t.string   "email"
    t.string   "work_email"
    t.string   "county"
    t.string   "home_phone"
    t.string   "cell_phone"
    t.string   "ssn_digest"
    t.string   "encrypted_ssn"
    t.string   "encrypted_ssn_iv"
    t.string   "dob"
    t.string   "address_1"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "address_2"
    t.integer  "user_id"
    t.integer  "placement_statuses_id"
    t.boolean  "veteran"
    t.string   "branch"
    t.date     "pay_entry_base_date"
    t.date     "end_of_active_service"
    t.date     "a_a_application_submitted"
    t.date     "benefit_received"
    t.boolean  "medicaid"
    t.boolean  "medicaid_icp"
    t.boolean  "medicaid_ltmc"
    t.text     "personal_history"
    t.text     "clinical_history"
    t.text     "financial"
    t.integer  "community_id"
    t.date     "placement"
    t.integer  "balance_cents"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["community_id"], name: "index_patients_on_community_id", using: :btree
    t.index ["placement_statuses_id"], name: "index_patients_on_placement_statuses_id", using: :btree
    t.index ["ssn_digest"], name: "index_patients_on_ssn_digest", unique: true, using: :btree
    t.index ["user_id"], name: "index_patients_on_user_id", using: :btree
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "amount_cents"
    t.integer  "company_id"
    t.integer  "invoice_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["company_id"], name: "index_payments_on_company_id", using: :btree
    t.index ["invoice_id"], name: "index_payments_on_invoice_id", using: :btree
  end

  create_table "pharmacies", force: :cascade do |t|
    t.string   "name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "phone_number"
    t.string   "fax"
    t.string   "website"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "community_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "zip_code_id"
    t.string   "email"
    t.integer  "communities_count"
    t.index ["community_id"], name: "index_pharmacies_on_community_id", using: :btree
    t.index ["zip_code_id"], name: "index_pharmacies_on_zip_code_id", using: :btree
  end

  create_table "photos", force: :cascade do |t|
    t.string   "image_data"
    t.integer  "community_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "orient"
    t.boolean  "viewable",     default: false
    t.index ["community_id"], name: "index_photos_on_community_id", using: :btree
  end

  create_table "placement_statuses", force: :cascade do |t|
    t.string "status"
  end

  create_table "positions", force: :cascade do |t|
    t.string  "title"
    t.boolean "clinician"
  end

  create_table "prospective_communities", force: :cascade do |t|
    t.integer "contact_id"
    t.integer "community_id"
    t.index ["community_id"], name: "index_prospective_communities_on_community_id", using: :btree
    t.index ["contact_id", "community_id"], name: "prospects_index", unique: true, using: :btree
    t.index ["contact_id"], name: "index_prospective_communities_on_contact_id", using: :btree
  end

  create_table "relationship_types", force: :cascade do |t|
    t.string "name"
    t.string "male_name"
    t.string "male_opposite"
    t.string "female_name"
    t.string "female_opposite"
    t.string "entanglement"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "relationship_type_id"
    t.integer "contact_id"
    t.integer "relation_id"
    t.boolean "step",                 default: false
    t.boolean "in_law",               default: false
    t.boolean "great",                default: false
    t.index ["contact_id", "relation_id", "relationship_type_id"], name: "unique_relationships", unique: true, using: :btree
    t.index ["contact_id"], name: "index_relationships_on_contact_id", using: :btree
    t.index ["relationship_type_id"], name: "index_relationships_on_relationship_type_id", using: :btree
  end

  create_table "respite_stays", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "community_id"
    t.datetime "start"
    t.datetime "stop"
    t.integer  "fee_cents",    default: 0,     null: false
    t.string   "fee_currency", default: "USD", null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["community_id"], name: "index_respite_stays_on_community_id", using: :btree
    t.index ["contact_id"], name: "index_respite_stays_on_contact_id", using: :btree
  end

  create_table "result_types", force: :cascade do |t|
    t.string "name"
  end

  create_table "results", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "result_type_id"
    t.datetime "created_at"
    t.integer  "community_id"
    t.integer  "rate_cents",             default: 0,     null: false
    t.string   "rate_currency",          default: "USD", null: false
    t.integer  "deferred_rate_cents",    default: 0,     null: false
    t.string   "deferred_rate_currency", default: "USD", null: false
    t.datetime "updated_at"
    t.index ["community_id"], name: "index_results_on_community_id", using: :btree
    t.index ["contact_id"], name: "index_results_on_contact_id", using: :btree
    t.index ["result_type_id"], name: "index_results_on_result_type_id", using: :btree
  end

  create_table "states", force: :cascade do |t|
    t.string   "name"
    t.string   "two_digit_code"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.boolean  "admin",             default: false
    t.boolean  "disable",           default: true
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "pic_link"
    t.text     "profile"
    t.index ["email"], name: "index_users_on_email", using: :btree
  end

  create_table "zip_codes", force: :cascade do |t|
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "city_id"
    t.index ["city_id"], name: "index_zip_codes_on_city_id", using: :btree
  end

  add_foreign_key "cities", "counties"
  add_foreign_key "communities", "users"
  add_foreign_key "communities", "zip_codes"
  add_foreign_key "community_medicaid_providers", "medicaid_providers"
  add_foreign_key "companies", "users"
  add_foreign_key "companies", "zip_codes"
  add_foreign_key "contacts", "companies"
  add_foreign_key "contacts", "users"
  add_foreign_key "contacts", "zip_codes"
  add_foreign_key "counties", "states"
  add_foreign_key "data_files", "users"
  add_foreign_key "pharmacies", "zip_codes"
  add_foreign_key "photos", "communities"
  add_foreign_key "prospective_communities", "communities"
  add_foreign_key "prospective_communities", "contacts"
  add_foreign_key "respite_stays", "communities"
  add_foreign_key "respite_stays", "contacts"
  add_foreign_key "results", "communities"
  add_foreign_key "results", "contacts"
  add_foreign_key "zip_codes", "cities"
end
