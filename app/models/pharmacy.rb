class Pharmacy < ActiveRecord::Base
  has_many  :communities
  has_many :notes, as: :notable
  belongs_to :zip_code
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: { maximum: 255 }, allow_blank: true,
          format: { with: VALID_EMAIL_REGEX }
  
  VALID_PHONE_REGEX = /(?:\d{1}\s)?\(?(\d{3})\)?-?\s?(\d{3})-?\s?(\d{4})/
  validates :phone_number, allow_blank: true, length: { in: 10..17 },
                    format: { with: VALID_PHONE_REGEX, 
                    message: "not a valid 10-digit phone number" }
  
  geocoded_by :full_street_address, if: ->(pharmacy){ pharmacy.address_1.present? and pharmacy.address_1_changed? }
  after_validation :geocode          # auto-fetch coordinates
  
  def self.search(search)
    if search
      where('name ilike ?', "%#{search}%")
    else
      nil
    end
  end
  
  def full_street_address
    if address_1
      [address_1, zip_code.city.name, zip_code.city.county.state.name, 'US'].compact.join(', ')
    end
  end
  
  def search
    
  end
end