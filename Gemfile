source 'https://rubygems.org'
ruby "2.4.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2'

# Bootstrap!
gem 'bootstrap-sass', '~> 3.3'
gem 'sass-rails', '~> 5.0'
gem "font-awesome-rails"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 3.2.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Add form validator plugin
gem 'jquery-form-validator-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'devise', '~> 3.5'
gem 'bcrypt', '~> 3.1'
gem 'cancancan', '~> 2.0'
gem 'spreadsheet'

gem 'select2-rails', '~> 4.0'
gem 'rack-google-analytics'

gem 'high_voltage', '~> 3.0'

group :development do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.3'
end

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  gem 'rspec-rails', '~> 3.6'
  gem 'cucumber-rails', require: false
  gem 'poltergeist'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'simplecov', :group => :test

  gem 'dotenv-rails'
end

group :production do
  # Postgres on Heroku in production
  gem 'pg', '0.21.0'
  gem 'rails_12factor' # For heroku
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
