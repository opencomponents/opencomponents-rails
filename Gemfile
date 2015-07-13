source 'https://rubygems.org'

gemspec

gem 'rake', '~> 10.4'

rails_version = ENV['RAILS_VERSION'] || '4.2'

gem 'rails', "~> #{rails_version}.0"

group :development do
  gem 'pry-byebug'
  gem 'awesome_print'
end

group :test do
  gem 'rspec', '~> 3.3'
  gem 'webmock', '~> 1.21'
end
