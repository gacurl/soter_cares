class Invoice < ActiveRecord::Base
  belongs_to :patients
  belongs_to :companies
  
  monetize :amount_cents
end
