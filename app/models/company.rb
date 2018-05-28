class Company < ActiveRecord::Base
  has_many :communities
  has_many :contacts
  has_many :payments
  has_many :invoices
  
  belongs_to :user
  belongs_to :zip_code
  
  has_many :notes, as: :notable, dependent: :destroy
  has_many :data_files, as: :fileable, dependent: :destroy
  
  validates :name, presence: true, length: { maximum: 50 }
  
  attribute :community, :string
  attribute :community_id, :integer
  
  def self.search(search)
    if search
      where('name ilike ?', "%#{search}%")
    else
      nil
    end
  end
end