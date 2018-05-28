class CommunityLicenseType < ActiveRecord::Base
  belongs_to :community
  belongs_to :license_type
end