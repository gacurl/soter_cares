class Community < ActiveRecord::Base
  acts_as_taggable_on :activities, :features, :dinings, :undesireds
  attribute   :activity_list_tokens, :string
  attribute   :dining_list_tokens, :string
  attribute   :feature_list_tokens, :string
  attribute   :undesired_list_tokens, :string
  attribute   :open_since_input, :string
  attribute   :semi_private_availability, :integer
  attribute   :private_availability, :integer
  attribute   :clinician_search, :string
  attribute   :clinician_id, :integer
  
  before_create :create_account_number
  
  has_many :data_files, as: :fileable, dependent: :destroy
  has_many :photos, dependent: :destroy
  
  belongs_to :company, counter_cache: true
  belongs_to :user
  belongs_to :executive_director, class_name: "Contact"
  belongs_to :nursing_director, class_name: "Contact"
  belongs_to :admissions_director, class_name: "Contact"
  belongs_to :marketing_director, class_name: "Contact"
  belongs_to :pharmacy, counter_cache: true
  belongs_to :zip_code
  has_many :availabilities, dependent: :destroy
  has_many :employees, class_name: "Contact", foreign_key: :community_id
  has_many :patients, class_name: "Contact", foreign_key: :facility_id
  
  has_many :community_activities, dependent: :destroy
  has_many :community_clinicians, dependent: :destroy
  has_many :clinicians, class_name: "Contact", through: :community_clinicians, source: :contact
  has_many :community_dinings, dependent: :destroy
  has_many :community_features, dependent: :destroy
  has_many :community_license_types, dependent: :destroy
  has_many :license_types, through: :community_license_types
  has_many :results, dependent: :destroy
  has_many  :prospective_communities, dependent: :destroy
  has_many  :leads, class_name: "Contact", through: :prospective_communities
  
  has_many :notes, as: :notable, dependent: :destroy
  has_many :community_medicaid_providers
  has_many :medicaid_providers, through: :community_medicaid_providers
  
  has_many :respite_stays
  
  monetize :semi_private_cents
  monetize :private_cents
  monetize :community_fee_cents
  monetize :respite_rate_cents
  monetize :adult_day_care_rate_cents
  monetize :pet_fee_cents
  monetize :second_person_fee_cents
  
  geocoded_by :full_street_address, if: ->(community){ community.address_1.present? and community.address_1_changed? }
  after_validation :geocode          # auto-fetch coordinates
  
  validates :name, presence: true, length: { maximum: 50 }

  def claim_email_contact
    marketing_director || admissions_director || executive_director
  end

  def send_claim_email(prospect_id, lead_id)
    ContactMailer.lead(self, prospect_id, lead_id).deliver_now
  end
  
  def self.with_licenses(license_ids)
    where("NOT EXISTS (SELECT * FROM license_types
      WHERE NOT EXISTS (SELECT * FROM community_license_types
        WHERE community_license_types.license_type_id = license_types.id
        AND community_license_types.community_id = communities.id)
      AND license_types.id IN (?))", license_ids)
  end
  
  def location
    "#{zip_code.city.name}, #{zip_code.city.county.state.two_digit_code}" if zip_code
  end
  
  def full_street_address
    if address_1 && zip_code
      [address_1, zip_code.city.name, zip_code.city.county.state.name, 'US'].compact.join(', ')
    end
  end
  
  def activity_list_tokens=(tokens)
    tags = []
    tokens.split(',').each do |token|
      tag = ActsAsTaggableOn::Tag.find_by_id(token.to_i)
      if tag.nil?
        name = token.gsub!(/<<<(.+?)>>>/) { $1 }
      else
        name = tag.name
      end
      tags << name
    end
    self.activity_list = tags
  end
  
  def dining_list_tokens=(tokens)
    tags = []
    tokens.split(',').each do |token|
      tag = ActsAsTaggableOn::Tag.find_by_id(token.to_i)
      if tag.nil?
        name = token.gsub!(/<<<(.+?)>>>/) { $1 }
      else
        name = tag.name
      end
      tags << name
    end
    self.dining_list = tags
  end
  
  def feature_list_tokens=(tokens)
    tags = []
    tokens.split(',').each do |token|
      tag = ActsAsTaggableOn::Tag.find_by_id(token.to_i)
      if tag.nil?
        name = token.gsub!(/<<<(.+?)>>>/) { $1 }
      else
        name = tag.name
      end
      tags << name
    end
    self.feature_list = tags
  end
  
  def undesired_list_tokens=(tokens)
    tags = []
    tokens.split(',').each do |token|
      tag = ActsAsTaggableOn::Tag.find_by_id(token.to_i)
      if tag.nil?
        name = token.gsub!(/<<<(.+?)>>>/) { $1 }
      else
        name = tag.name
      end
      tags << name
    end
    self.undesired_list = tags
  end
  
  def self.search(search)
    if search
      where('name ilike ?', "%#{search}%")
    else
      nil
    end
  end
  
  private
    def create_account_number
      begin
        self.account_number = SecureRandom.hex(4).upcase
      end while Community.where(account_number: self.account_number).exists?
    end
end