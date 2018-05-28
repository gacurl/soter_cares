class MedicaidProvider < ApplicationRecord
  has_many :community_medicaid_providers
  has_many :communities, through: :community_medicaid_providers
  has_many :contacts
end
