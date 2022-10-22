# frozen_string_literal: true 

require 'http'
require 'json'
require 'yaml'
require_relative 'flight_info'

# airport token 
airport_token = AuthToken.new('config/secrets.yml')
puts airport_token.obtain_token