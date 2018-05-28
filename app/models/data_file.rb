class DataFile < ApplicationRecord
  include FileUploader[:file]
  
  belongs_to :user
  belongs_to :fileable, polymorphic: true
  
  before_create :create_storage
  
  def import(file)
    s3 = Aws::S3::Resource.new
    obj = s3.bucket(ENV["S3_BUCKET"]).object(self.storage) 
    obj.upload_file(file.path)
  end
  
  def load_file
    s3 = Aws::S3::Resource.new
    s3.bucket(ENV["S3_BUCKET"]).object(self.storage)
  end
  
  def unload_file
    File.delete("tmp/" + self.storage)
  end
  
  private
    def create_storage
      begin
        self.storage = SecureRandom.hex(32)
      end while DataFile.where(storage: self.storage).exists?
    end
end
