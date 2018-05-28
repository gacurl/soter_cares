class Payment < ActiveRecord::Base
  belongs_to :invoices
  belongs_to :companies
  
  monetize :amount_cents
end
