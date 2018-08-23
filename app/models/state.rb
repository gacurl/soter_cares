class State < ActiveRecord::Base
  has_many :counties, dependent: :destroy
  has_many :cities, through: :counties
  validates :name,           presence: true, uniqueness: {case_sensitive: false}
  validates :two_digit_code, presence: true, uniqueness: {case_sensitivie: false}


  def self.fetch_states
    states = $redis.get("states")
    if states.nil?
      states = State.all.to_json
      $redis.set("states", states)
    end
    JSON.load states
  end
end
