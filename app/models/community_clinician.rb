class CommunityClinician < ActiveRecord::Base
  belongs_to :community
  belongs_to :contact
end