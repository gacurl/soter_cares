class RespiteStay < ApplicationRecord
  belongs_to :contact
  belongs_to :community
  
  monetize :fee_cents
end
