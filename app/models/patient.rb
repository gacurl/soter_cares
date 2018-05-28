class Patient < ActiveRecord::Base
  has_many :notes, as: :notable
  has_one :placement_status
  
  belongs_to :community
  belongs_to :user
  
  attr_encrypted :ssn, key: Rails.application.secrets.secret_key_base
end
