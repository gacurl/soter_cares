class Result < ActiveRecord::Base
  belongs_to  :contact
  belongs_to  :result_type
  belongs_to  :community
  
  monetize :rate_cents
  monetize :deferred_rate_cents
end