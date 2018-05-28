class CommunityFeature < ActiveRecord::Base
  belongs_to :community
  belongs_to :feature
end