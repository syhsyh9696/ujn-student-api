if Rails.env.development?
  GrapeSwaggerRails.options.url = "swagger_doc"
  GrapeSwaggerRails.options.app_name = 'My App'
  GrapeSwaggerRails.options.app_url = '/api/'
end
