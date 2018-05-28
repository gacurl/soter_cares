class LicenseType < ActiveRecord::Base
  acts_as_taggable_on :licenses
  has_many :community_license_types
  has_many :communities, through: :community_license_types
end