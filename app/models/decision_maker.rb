class DecisionMaker < ActiveRecord::Base
  belongs_to :contact
  belongs_to :relationship
end