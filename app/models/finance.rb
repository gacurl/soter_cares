class Finance < ActiveRecord::Base
  belongs_to :contact
  
  monetize :checking_cents
  monetize :savings_cents
  monetize :money_market_cents
  monetize :life_insurance_cents
  monetize :veterans_aid_cents
  monetize :health_savings_cents
  monetize :other_cash_cents
  monetize :securities_cents
  monetize :treasury_bills_cents
  monetize :other_investments_cents
  monetize :retirement_accounts_cents
  monetize :pension_annuity_cents
  monetize :social_security_cents
  monetize :other_retirement_cents
  monetize :real_estate_cents
  monetize :automobile_cents
  monetize :other_property_cents
  monetize :notes_receivable_cents
  monetize :accounts_payable_cents
  monetize :auto_loan_cents
  monetize :credit_card_debt_cents
  monetize :mortgage_cents
  monetize :other_liabilities_cents
  monetize :liquid_cents
  monetize :hard_cents
  monetize :short_cents
  monetize :long_cents
  monetize :monthly_cents
  monetize :medicaid_cents
  
  def liquid_cents
    checking_cents + savings_cents + money_market_cents + life_insurance_cents + 
    health_savings_cents + other_cash_cents + securities_cents + treasury_bills_cents +
    other_investments_cents
  end
  
  def hard_cents
    real_estate_cents + automobile_cents + other_property_cents + retirement_accounts_cents +
    notes_receivable_cents
  end
  
  def short_cents
    accounts_payable_cents + credit_card_debt_cents + other_liabilities_cents
  end
  
  def long_cents
    mortgage_cents + auto_loan_cents
  end
  
  def monthly_cents
    veterans_aid_cents + pension_annuity_cents + social_security_cents + other_retirement_cents
  end
end