class CommunityDining < ActiveRecord::Base
  belongs_to :community
  belongs_to :dining
end