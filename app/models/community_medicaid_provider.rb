class CommunityMedicaidProvider < ApplicationRecord
  belongs_to :medicaid_provider
  belongs_to :community
end
