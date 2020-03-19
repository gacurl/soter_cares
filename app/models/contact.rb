class Contact < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  acts_as_taggable_on :activities, :licenses, :features, :dinings, :undesireds
  attribute   :activity_list_tokens, :string
  attribute   :dining_list_tokens, :string
  attribute   :feature_list_tokens, :string
  attribute   :undesired_list_tokens, :string
  attribute   :license_list_tokens, :string
  attribute   :community_search, :string
  attribute   :clinic_id, :integer
  
  has_many :data_files, as: :fileable
  
  belongs_to :medicaid_provider
  belongs_to  :community
  belongs_to  :zip_code
  belongs_to  :company
  belongs_to   :position
  has_many     :results, dependent: :destroy
  has_one     :finance
  has_many :referrals, class_name: "Contact",
                          foreign_key: "referrer_id"
  belongs_to :referrer, class_name: "Contact"
  
  has_many  :decision_makers, dependent: :destroy
  has_many  :community_clinicians
  has_many  :clinics, class_name: "Community", through: :community_clinicians, source: :community
  has_many  :contact_results, dependent: :destroy
  has_many :marketing_community, class_name: "Community", foreign_key: :marketing_director_id
  has_many :executive_community, class_name: "Community", foreign_key: :executive_director_id
  has_many :nursing_community, class_name: "Community", foreign_key: :nursing_director_id
  has_many :admissions_community, class_name: "Community", foreign_key: :admissions_director_id
  has_many :prospective_communities
  has_many :prospects, class_name: "Community", through: :prospective_communities
  has_many :notes, as: :notable
  has_many :relationships, dependent: :destroy
  has_many :relations, through: :relationships
  belongs_to  :placement_status
  
  belongs_to :facility, class_name: "Community"
  belongs_to :user
  has_many :respite_stays
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  validate :check_contact_type
  validate :email_phone_present
  validates :email, length: { maximum: 255 }, allow_blank: true,
          format: { with: VALID_EMAIL_REGEX }
  validates :work_email, length: { maximum: 255 }, allow_blank: true,
          format: { with: VALID_EMAIL_REGEX }        
  
  VALID_PHONE_REGEX = /(?:\d{1}\s)?\(?(\d{3})\)?-?\s?(\d{3})-?\s?(\d{4})/
  validates :work_phone, allow_blank: true, length: { in: 10..17 },
                    format: { with: VALID_PHONE_REGEX, 
                    message: "not a valid 10-digit phone number" }
  
  validates :home_phone, allow_blank: true, length: { in: 10..17 },
                    format: { with: VALID_PHONE_REGEX, 
                    message: "not a valid 10-digit phone number" }
                    
  validates :cell_phone, allow_blank: true, length: { in: 10..17 },
                    format: { with: VALID_PHONE_REGEX, 
                    message: "not a valid 10-digit phone number" }
  
  VALID_SSN_REGEX = /\A[0-8]\d{2}?\d{2}?\d{4}\z/
  validates :ssn, length: { is: 9 }, numericality: true, allow_blank: true,
                    format: { with: VALID_SSN_REGEX }
  validates :ssn_digest, uniqueness: true, allow_blank: true
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  
  before_save :add_to_mailchimp
  before_validation :create_ssn_digest
  before_create :default_values
  before_save   :create_case_id
  after_create  :create_decision_makers
  before_save   :check_placement_status
  before_save :generate_code
#  before_save :case_manager_check
  
  attr_encrypted :ssn, key: Rails.application.secrets.secret_key_base
  
  attribute :hierarchy, :string
  attribute :resident_search, :string
  attribute :family_search, :string
  attribute :relation_id, :string
  attribute :salutation_male, :string
  attribute :salutation_female, :string
  attribute :male_relationship_type, :integer
  attribute :female_relationship_type, :integer
  attribute :pay_entry_base_date_input, :string
  attribute :placement_input, :string
  attribute :dob_input, :string
  attribute :benefit_received_input, :string
  attribute :end_of_active_service_input, :string
  attribute :va_application_submitted_input, :string
  
  phony_normalize :cell_phone, default_country_code: 'US'
  phony_normalize :home_phone, default_country_code: 'US'
  phony_normalize :work_phone, default_country_code: 'US'
  
   scope :lead_to_pursue, -> { joins(:results)
    .where('results.created_on = (SELECT MAX(results.created_on) FROM results WHERE results.contact_id = contacts.id)')
    .where('results.result_type = Qualified') }

  def send_claim_email(prospect_id)
    ContactMailer.claim(self, prospect_id).deliver_now
  end

  def case_manager_check
    if self.contact_type == "Resident"
      if self.user && self.user_id_changed?
        self.user.send_lead_email(self.id)
      end
    end
  end
  
  def send_validation_email(prospect_id)
    ContactMailer.validation(self, prospect_id).deliver_now
  end
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def company_name
    company.name if company
  end
  
  def position_title
    position.title if position
  end
  
  def facility_name
    facility.name if facility
  end
  
  def location
    "#{zip_code.city.name}, #{zip_code.city.county.state.two_digit_code}" if zip_code
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
  
  def license_list_tokens=(tokens)
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
    self.license_list = tags
  end
  
  
  
  def new_license_list_tokens=(tokens)
    tags = []
    tokens.each do |token|
      tag = ActsAsTaggableOn::Tag.find_by_id(token.to_i)
      if tag.nil?
        name = token.gsub!(/<<<(.+?)>>>/) { $1 }
      else
        name = tag.name
      end
      tags << name
    end
    self.license_list = tags
  end
  
  def new_activity_list_tokens=(tokens)
    tags = []
    tokens.each do |token|
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
  
  def create_decision_makers
    if contact_type == "Resident"
      x = 1
      4.times { 
        self.decision_makers << DecisionMaker.create(hierarchy: x)
        x += 1
      }
    end
  end
  
  def default_values
    if self.contact_type == "Resident"
      self.placement_status = PlacementStatus.find_by(status: "Date not set")
      self.finance = Finance.new
    end
  end
  
  def self.search(search)
    if search
      if search.is_number?
        where(ssn_digest: Contact.digest(search))
      elsif search.kind_of?(Date)
          where('dob = ?',"%#{Date.parse(search)}%")
      else
            where('last_name ilike ? OR first_name ilike ? OR first_name ilike ? AND last_name ilike ?',
                  "%#{search}%", "%#{search}%", "%#{search.split[0]}%", "%#{search.split[1]}%")
      end
    else
      nil
    end
  end
  
  def check_contact_type
    if contact_type != "Resident" && contact_type != "Business" && contact_type != "Family"
      errors.add(:contact_type, "must be selected as Resident, Business, or Family")
    end
  end

  def email_phone_present
    if web_lead?
      if email.blank? && cell_phone.blank?
        errors.add(:base, "Please include a phone number or email")
      end
    end
  end
  
  def check_placement_status
    if self.placement_status != PlacementStatus.find_by(status: "Placed")
      if self.placement.present?
        self.placement_status = PlacementStatus.find_by(status: "Date selected")
      elsif self.placement.nil?
        self.placement_status = PlacementStatus.find_by(status: "Date not set")
      end
    end
  end
  
  def send_code
    if self.cell_phone
      text = "Your SOTER validation code is: #{self.phone_code}"
      @client = Twilio::REST::Client.new Rails.application.secrets.twilio_sid, Rails.application.secrets.twilio_auth_token
       resp = @client.api.account.messages.create(
         from: Rails.application.secrets.twilio_number,
         to: self.cell_phone,
         body: text
       )
     end
  end
  
  private
    def add_to_mailchimp
      if self.community.present? || self.marketing_community.present? || 
          self.executive_community.present? || self.nursing_community.present? ||
          self.admissions_community.present?
        gibbon = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp)
        begin
          if self.work_email.present? && self.new_record? || self.work_email_changed?
            gibbon.lists('d90e69ee35').members.create(body: {email_address: self.work_email, status: "subscribed", merge_fields: {FNAME: self.first_name, LNAME: self.last_name}}) 
          end
        rescue Gibbon::MailChimpError
        end
      end
    end
  
    def Contact.digest(string)
      Digest::MD5.hexdigest(string.to_s)
    end
  
    def create_case_id
      if contact_type == "Resident" && case_id.nil?
        begin
          o = [('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
          string = (0...9).map { o[rand(o.length)] }.join
          self.case_id = string
        end while Contact.where(case_id: self.case_id).exists?
      end
    end
    
    def create_ssn_digest
      if !self.ssn.blank?
        self.ssn_digest = Contact.digest(self.ssn)
      else
        self.ssn_digest = nil
      end
    end
    
    def generate_code
      self.phone_code = SecureRandom.random_number(9999) unless self.phone_code
    end
end

class String
  def is_number?
    true if Float(self) rescue false
  end
end