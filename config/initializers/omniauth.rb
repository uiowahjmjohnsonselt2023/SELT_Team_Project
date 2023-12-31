Rails.application.config.middleware.use OmniAuth::Builder do
    puts "Omniauth initialized"
    provider :github, ENV['CLIENT_ID'], ENV['CLIENT_SECRET']
    provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
end