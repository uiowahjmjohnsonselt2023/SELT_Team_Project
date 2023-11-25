require 'dragonfly'
require 'dragonfly/s3_data_store' 

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "81f64555bde6a185d31975b273eb265789e286ba227280bf0f556a31280eb1d6"

  url_format "/media/:job/:name"

  if Rails.env.development? || Rails.env.test?
    datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
  else
    datastore :file,
      root_path: Rails.root.join('public/system/dragonfly', Rails.env),
      server_root: Rails.root.join('public')
    # datastore :s3,
    #   bucket_name: 'team007-selt-project',
    #   access_key_id: ENV['AWS_KEY'],
    #   secret_access_key: ENV['AWS_SEC'],
    #   url_scheme: 'https',
    #   region: 'us-east-2'
  end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
ActiveSupport.on_load(:active_record) do
  extend Dragonfly::Model
  extend Dragonfly::Model::Validations
end
