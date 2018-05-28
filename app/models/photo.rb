class Photo < ApplicationRecord
  belongs_to :community
  
  include ImageUploader[:image]
  
end
