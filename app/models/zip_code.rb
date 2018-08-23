class ZipCode < ActiveRecord::Base
  belongs_to :city
  has_many :contacts
  has_many :communities
  has_many :companies
  has_many :pharmacies

  validates :city, presence: true
  validates :code, presence: true, uniqueness: {case_sensitive: false}
  
  def self.search(search)
    if search
      where('code ilike ?', "%#{search}%")
    else
      nil
    end
  end

  def self.fetch_zip_list
    zips = $redis.get("zip_list")

    if zips.nil?
      zips = ZipCode.all.map do |zip|
        { id: zip.id, city: zip.city.name, state: zip.city.county.state.two_digit_code, zip: zip.code }
      end
      zips = zips.to_json.to_s
      $redis.set("zip_list", zips)
    end

    JSON.load zips
  end

  def self.fetch_zips
    zips = $redis.get("zips")
    if zips.nil?
      zips = ZipCode.all.to_json
      $redis.set("zips", zips)
    end
    JSON.load zips
  end
end
