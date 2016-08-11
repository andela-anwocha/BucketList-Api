source "https://rubygems.org"

gem "rails", "4.2.6"

gem "rails-api"

gem "active_model_serializers"

gem "jwt"

gem "bcrypt"

group :development, :test do
  gem "rspec-rails", "~> 3.5"
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "shoulda-matchers", "~> 3.1"
  gem "sqlite3"
  gem "faker"
  gem "rubocop"
  gem "pry-rails"
  gem "spring"
  gem "simplecov", require: false
  gem "coveralls", require: false
end

group :production do
  gem "pg"
  gem "rails_12factor"
end
