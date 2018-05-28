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
end
