class Photo < ApplicationRecord
  belongs_to :community
  
  include ImageUploader[:image]

  def original_filename
    if image.is_a?(Hash)
      image[:original]&.original_filename
    else
      image.original_filename
    end
  end

  def download
    if image.is_a?(Hash)
      image[:original]&.download
    else
      image.download
    end
  end

  def url(options)
    if image.is_a?(Hash)
      image[:original]&.url(
          response_content_disposition: options[:response_content_disposition],
          virtual_host: options[:virtual_host],
          host: options[:host]
      )
    else
      image.url(
          response_content_disposition: options[:response_content_disposition],
          virtual_host: options[:virtual_host],
          host: options[:host]
      )
    end
  end
end
