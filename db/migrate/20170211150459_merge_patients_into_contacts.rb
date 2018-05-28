class MergePatientsIntoContacts < ActiveRecord::Migration[5.0]
  def change
    add_reference :contacts,  :placement_status
    add_reference :contacts,  :patient_community
    add_column    :contacts,  :veteran,             :boolean
    add_column    :contacts,  :pay_entry_base_date, :date  
    add_column    :contacts,  :end_of_active_service, :date  
    add_column    :contacts,  :aa_application_submitted, :date  
    add_column    :contacts,  :benefit_received, :date  
    add_column    :contacts,  :placement, :date  
    add_column    :contacts,  :medicaid, :boolean 
    add_column    :contacts,  :medicaid_icp, :boolean 
    add_column    :contacts,  :medicaid_ltmc, :boolean 
    add_column    :contacts,  :deceased, :boolean 
    add_column    :contacts,  :personal_history, :text 
    add_column    :contacts,  :clinical_history, :text 
  end
  
  drop_table :patients
  
  create_table :finances do |t|
    t.references :contact
    t.monetize  :checking
    t.monetize  :savings
    t.monetize  :money_market
    t.monetize  :life_insurance
    t.monetize  :veterans_aid
    t.monetize  :health_savings
    t.monetize  :other_cash
    t.monetize  :securities
    t.monetize  :treasury_bills
    t.monetize  :other_investments
    t.monetize  :retirement_accounts
    t.monetize  :pension_annuity
    t.monetize  :social_security
    t.monetize  :other_retirement
    t.monetize  :real_estate
    t.monetize  :automobile
    t.monetize  :other_property
    t.monetize  :notes_receivable
    t.monetize  :accounts_payable
    t.monetize  :auto_loan
    t.monetize  :credit_card_debt
    t.monetize  :mortgage
    t.monetize  :other_liabilities
    
    t.timestamps
  end
  
end
