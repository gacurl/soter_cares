class State < ActiveRecord::Base
  has_many :counties, dependent: :destroy
  has_many :cities, through: :counties
  validates :name,           presence: true, uniqueness: {case_sensitive: false}
  validates :two_digit_code, presence: true, uniqueness: {case_sensitivie: false}
end
