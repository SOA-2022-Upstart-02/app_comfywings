# frozen_string_literal: true

source 'https://rubygems.org'

# configuration and utilities
gem 'figaro', '~> 1.2'
gem 'rake', '~> 13.0'

# Web Application
gem 'puma', '~> 5'
gem 'rack-session', '~> 0.3'
gem 'roda', '~> 3'
gem 'slim', '~> 4'

# Database
gem 'hirb', '~> 0'
gem 'hirb-unicode', '~> 0'
gem 'sequel', '~> 5.49'

group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'pg', '~> 1.2'
end

# Networking
gem 'http', '~> 5'

# Testing
group :development, :test do
  gem 'minitest'
  gem 'minitest-rg', '~> 5'
  gem 'simplecov', '~> 0'
  gem 'vcr', '~> 6'
  gem 'webmock', '~> 3'
end
# Validation
gem 'dry-struct', '~> 1'
gem 'dry-types', '~> 1'

# Debugging
gem 'pry'

# Code Quality
group :development do
  gem 'flog'
  gem 'reek'
  gem 'rubocop'
end
