class City < ActiveRecord::Base
  belongs_to :county
  has_many   :zip_codes, dependent: :destroy

  after_save :clear_cache

  validates :county, presence: true
  validates :name,   presence: true, uniqueness: {case_sensitive: false, scope: :county_id}

  def state
    county.state.two_digit_code
  end

  def clear_cache
    $redis.del "cities"
  end

  def cached_cities
    Rails.cache.fetch("cities") { cities.to_json }
  end

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

  def self.fetch_city_list
    cities = $redis.get("city_list")

    if cities.nil?
      cities = City.all.map do |city|
        { id: city.id, name: city.name, state: city.county.state.two_digit_code }
      end
      cities = cities.to_json.to_s
      $redis.set("city_list", cities)
    end

    JSON.load cities
  end

  def self.fetch_cities
    cities = $redis.get("cities")
    if cities.nil?
      cities = City.all.to_json
      $redis.set("cities", cities)
    end
    JSON.load cities
  end
end
