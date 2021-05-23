class ImageUploader < Shrine
  include ImageProcessing::MiniMagick
  plugin :processing
  plugin :versions
  plugin :determine_mime_type, analyzer: :mime_types
  
  process(:store) do |io, context|
    original = io.download
    pipeline = ImageProcessing::MiniMagick.source(original)
    size_800 = pipeline.resize_to_limit!(800, 800)

    original.close!

    { original: io, large: size_800 }
  end
end