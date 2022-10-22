# frozen_string_literal: true

require 'http'
require 'json'
require 'yaml'
require_relative 'flight_info'

# airport token
AuthToken.new('config/secrets.yml')
