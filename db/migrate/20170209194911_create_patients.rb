class CreatePatients < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string    :name
      t.string    :address_1 
      t.string    :address_2 
      t.string    :city 
      t.string    :state 
      t.string    :zip 
      t.string    :phone_number 
      t.string    :fax 
      t.string    :website
      t.float    "latitude"
      t.float    "longitude"
      t.timestamps
    end
    
    create_table :positions do |t|
      t.string :title
      
    end
    
    create_table :contacts do |t|
     t.string   "first_name"
      t.string   "middle_name"
      t.string   "last_name"
      t.string    :salutation
      t.string    :gender
      t.string    :email
      t.string    :work_email
      t.string    :county
      t.string   "home_phone"
      t.string   "cell_phone"
      t.string   "ssn_digest"
      t.string   "encrypted_ssn"
      t.string   "encrypted_ssn_iv"
      t.date      :dob
      t.string   "address_1"
      t.string   :city
      t.string   "state"
      t.string   "zip"
      t.string   "address_2"
      t.float    "latitude"
      t.float    "longitude"
      t.references :position
      t.references :community
      t.index ["ssn_digest"], name: "index_contacts_on_ssn_digest", unique: true, using: :btree
      t.timestamps 
      
    end
    
    create_table :results do |t|
      t.string :result_type
    end
    
    create_table :contact_results do |t|
      t.references :result
      t.references :contact
      t.timestamps
    end
    
    create_table :pharmacies do |t|
      t.string    :name
      t.string    :address_1 
      t.string    :address_2 
      t.string    :city 
      t.string    :state 
      t.string    :zip 
      t.string    :phone_number 
      t.string    :fax 
      t.string    :website
      t.float    "latitude"
      t.float    "longitude"
      t.references :company
      t.timestamps
    end
    
    create_table :communities do |t|
      t.string  :account_number
      t.references :company
      t.references :executive_director
      t.references :nursing_director
      t.string  :name
      t.string   "address_1"
      t.string   :city
      t.string   "state"
      t.string   "zip"
      t.string   "address_2"
      t.float    "latitude"
      t.float    "longitude"
      t.date    :open_since
      t.integer :semi_private_capacity
      t.integer :semi_private_cents
      t.integer :private_capacity
      t.integer :private_cents
      t.integer :community_fee_cents
      t.integer :respite_rate_cents
      t.integer :adult_day_care_rate
      t.boolean :pets
      t.references :pharmacy
      t.references :clinician
      t.boolean   :transport
      
      t.timestamps
    end
    
    create_table :dinings do |t|
      t.string :dining_type
    end
    
    create_table :activities do |t|
      t.string :activity_type
      t.string :name
    end
    
    create_table :features do |t|
      t.string :feature_type
      t.string :name
    end
    
    create_table :community_dinings do |t|
      t.references :dinings
      t.references :communities
    end
    
    create_table :community_activities do |t|
      t.references :activities
      t.references :communities
    end
    
    create_table :community_featuress do |t|
      t.references :features
      t.references :communities
    end
    
    
    create_table :availabilities do |t|
      t.references :communities
      t.string :capacity_type
      t.integer :number_available
      t.timestamps
    end
    
    
    create_table :license_types do |t|
      t.string :name
    end
    
    create_table :community_license_types do |t|
      t.references :license_types
      t.references :communities
    end
    
    create_table :placement_statuses do |t|
      t.string :status
    end
    
    create_table :patients do |t|
      t.string   "first_name"
      t.string   "middle_name"
      t.string   "last_name"
      t.string    :salutation
      t.string    :gender
      t.string    :email
      t.string    :work_email
      t.string    :county
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
      
      t.references :user
      t.references :placement_statuses
      t.boolean   :veteran
      t.string    :branch
      t.date      :pay_entry_base_date
      t.date      :end_of_active_service
      t.date      :a_a_application_submitted
      t.date      :benefit_received
      t.boolean   :medicaid
      t.boolean   :medicaid_icp
      t.boolean   :medicaid_ltmc
      t.text      :personal_history
      t.text      :clinical_history
      t.text      :financial
      t.references :community
      t.date      :placement
      t.integer   :balance_cents
      
      t.float    "latitude"
      t.float    "longitude"
      t.index ["ssn_digest"], name: "index_patients_on_ssn_digest", unique: true, using: :btree
      t.timestamps
    end
    
    create_table :invoices do |t|
      t.references :patient
      t.references :community
      t.integer   :amount_cents
      t.date      :due_date
      
      t.timestamps
    end
    
    create_table :payments do |t|
      t.integer :amount_cents
      t.references :company
      t.references :invoice
      
      t.timestamps
    end
    
    create_table :relationships do |t|
      t.references :relatable, polymorphic: true, index: true
      t.references :relationship_type
    end
    
    create_table :relationship_types do |t|
      t.string :name
    end
    
    
    create_table :decision_makers do |t|
      t.references :patient
      t.references :contact
      t.references :relationship
    end
    
    create_table :notes do |t|
      t.text  :content
      t.references :notable, polymorphic: true, index: true
      t.references :user
      
      t.timestamps
    end
  end
end

