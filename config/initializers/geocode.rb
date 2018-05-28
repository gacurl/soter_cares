# config/initializers/geocoder.rb

if Rails.env.production?
  Geocoder.configure(
    :http_proxy => ENV['QUOTAGUARD_URL'],
    :timeout => 5
  )
end