require "shrine/storage/s3"
require "shrine/storage/memory"

s3_options = {
    access_key_id:     Rails.application.secrets.aws_access_key_id,
    secret_access_key: Rails.application.secrets.aws_secret_access_key,
    region:            Rails.application.secrets.aws_region,
    bucket:            Rails.application.secrets.aws_bucket,
}

if Rails.env.test?
  Shrine.storages = {
      cache: Shrine::Storage::Memory.new,
      store: Shrine::Storage::Memory.new,
  }
else
  Shrine.storages = {
      cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
      store: Shrine::Storage::S3.new(prefix: "store", **s3_options),
  }
end

Shrine.plugin :presign_endpoint, presign_options: -> (request) {
  # Uppy will send the "filename" and "type" query parameters
  filename = request.params["filename"]
  type     = request.params["type"]
  
  {
      content_disposition:    ContentDisposition.inline(filename), # set download filename
      content_type:           type,                                # set content type (required if using DigitalOcean Spaces)
      content_length_range:   0..(10*1024*1024),                   # limit upload size to 10 MB
  }
}

Shrine.logger = Rails.logger
Shrine.logger.level = Logger::WARN

Shrine.plugin :activerecord
# Shrine.plugin :direct_upload
# Shrine.plugin :upload_endpoint
Shrine.plugin :restore_cached_data
Shrine.plugin :determine_mime_type
