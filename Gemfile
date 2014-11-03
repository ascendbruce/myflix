source 'https://rubygems.org'
ruby '2.0.0'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'

gem 'bootstrap_form', github: "bootstrap-ruby/rails-bootstrap-forms"
gem "bcrypt-ruby"

gem 'pry-rails'
gem "awesome_print"

gem 'unicorn'
gem "sidekiq"
gem "sentry-raven", :git => "https://github.com/getsentry/raven-ruby.git"
gem 'paratrooper'

gem 'carrierwave'
gem 'mini_magick'
gem "fog"

gem "stripe"
gem "figaro"

group :development do
  gem 'sqlite3'
  gem 'pry-remote'
  gem 'pry-debugger'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem "fuubar"
  gem 'spring-commands-rspec'
  gem 'guard-rspec'
  gem "guard-ctags-bundler"
  gem "terminal-notifier-guard"
  gem 'rb-fsevent', require: false
end

group :test do
  gem 'shoulda-matchers'
  gem 'fabrication'
  gem 'faker'
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

# require "pry-remote"; binding.remote_pry # trigger a remote pry debugger session
# netstat -anp tcp | grep 9876             # find the pid to kill in case that the pry-remote server crashed
