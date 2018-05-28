class County < ActiveRecord::Base
  belongs_to :state
  has_many   :cities, dependent: :destroy

  validates :state, presence: true
  validates :name,  presence: true, uniqueness: {case_sensitive: false, scope: :state_id}
end
