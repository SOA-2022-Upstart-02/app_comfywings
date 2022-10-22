# frozen_string_literal: true

require 'http'
require 'json'
require 'yaml'
require_relative 'flight_info'

# airport token
AuthToken.new('config/secrets.yml')

# TODO: the following
# Need depature code to obtain airport information
# example https://test.api.amadeus.com/v1/airport/direct-destinations?departureAirportCode=MAD&max=2
# try using current TPE code
