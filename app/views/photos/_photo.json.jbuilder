json.extract! photo, :id, :created_at, :updated_at
json.image_url photo.image.url
json.url community_photo_url(@community, photo, format: :json)
