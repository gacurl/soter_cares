class ContactResult < ActiveRecord::Base
  belongs_to :contacts
  belongs_to :results
end