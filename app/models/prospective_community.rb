class ProspectiveCommunity < ActiveRecord::Base
  belongs_to :prospect, class_name: "Community", foreign_key: :community_id
  belongs_to :lead, class_name: "Contact", foreign_key: :contact_id
end