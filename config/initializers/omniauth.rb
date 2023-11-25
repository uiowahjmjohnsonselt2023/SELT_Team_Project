Rails.application.config.middleware.use OmniAuth::Builder do
    puts "Got to omniauth"
    provider :github, ENV['CLIENT_ID'], ENV['CLIENT_SECRET']
end