class City < ActiveRecord::Base
  belongs_to :county
  has_many   :zip_codes, dependent: :destroy

  validates :county, presence: true
  validates :name,   presence: true, uniqueness: {case_sensitive: false, scope: :county_id}
  
  def self.search(search)
    
    if search
      state = State.find_by(two_digit_code:search.split(", ").last)
      
      if state
        state.cities.where('cities.name ilike ?', "%#{search.split(", ").first}%")
      else
            where('cities.name ilike ?', "%#{search.split(", ").first}%")
      end
    else
      nil
    end
  end
end
