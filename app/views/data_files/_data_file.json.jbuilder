json.extract! @data_file, :id, :created_at, :updated_at
disposition = "filename=#{@data_file.file.original_filename.inspect}"
json.file_url @data_file.file.url(response_content_disposition: disposition, virtual_host: true, host: "https://storage.sotercares.com")
json.file_name @data_file.file.data["metadata"]["filename"]
json.file_date @data_file.created_at.strftime("%m/%d/%Y-%T")
json.file_poster_name @data_file.user.name
json.url polymorphic_url([@object, @data_file], format: :json)