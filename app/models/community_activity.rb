class CommunityActivity < ActiveRecord::Base
  belongs_to :community
  belongs_to :activity
end