source 'https://rubygems.org'

ruby '2.6.6'
gem 'rails', '4.2.11'

gem 'sass-rails', '~> 5.0.3'
gem 'uglifier', '>= 2.7.1'

gem 'jquery-rails'

gem 'nokogiri', '~> 1.13.10'
gem 'puma'
gem 'bcrypt', '~> 3.1.7'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'byebug'
  gem 'simplecov', require: false
  gem 'factory_bot_rails'
  gem 'cucumber-rails', require: false
  gem 'rspec-rails'
end

# for Heroku deployment - as described in Ap. A of ELLS book
group :development, :test do
  gem 'database_cleaner'
  # gem 'database_cleaner-active_record'
  # gem 'database_cleaner-sequel'
  gem 'pry'
  gem 'pry-byebug'

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '~> 1.3.6'
end

group :production do
  gem 'pg', '~> 1.0.0'
  gem 'rails_12factor'
end

