source 'https://rubygems.org'

ruby '2.2.1'
gem 'rails', '4.2.4'
gem 'pg', '~> 0.18.4'
gem 'haml-rails', '~> 0.5.3'
gem 'unicorn', '~> 4.9.0' # Heroku https://devcenter.heroku.com/articles/ruby-default-web-server
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'therubyracer', '~> 0.12.2', platforms: :ruby
gem 'simple_form', '~> 3.1.0.rc2'
gem 'devise'
gem 'kaminari'
gem 'bootstrap-kaminari-views'
gem 'ransack'
gem 'jquery-rails', '~> 4.0.5'
gem 'twitter-bootstrap-rails'
gem 'actionview-encoded_mail_to'
gem 'mail_form'
gem 'exception_notification'

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring', '~> 1.3.6'
  gem 'letter_opener', '~> 1.2.0'
  gem 'binding_of_caller', '~> 0.7.2'
  gem 'quiet_assets', '~> 1.1.0'
  gem 'guard', '~> 2.13.0'
  gem 'guard-rspec', '~> 4.6.4', require: false
  gem 'capistrano-rails', '~> 1.1.2'
  gem 'capistrano-rvm'
end

group :development, :test do
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'rspec-rails', '~> 3.3.3'
  gem 'pry-rails', '~> 0.3.2'
  gem 'dotenv-rails', '~> 0.9.0'
end

group :test do
  gem 'shoulda-matchers', '~> 2.7.0', require: false
  gem 'capybara', '~> 2.5.0'
  gem 'email_spec'
end