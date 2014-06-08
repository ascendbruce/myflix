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

group :development do
  gem 'sqlite3'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-debugger'
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "awesome_print"
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
  gem 'launchy'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

# require "pry-remote"; binding.remote_pry # trigger a remote pry debugger session
# netstat -anp tcp | grep 9876             # find the pid to kill in case that the pry-remote server crashed
