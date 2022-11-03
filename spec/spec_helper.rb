# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../require_app'
require_app

# TODO: add/move required libraries, constants, and files required for tests
#       when you write or create a new test
AMADEUS_KEY = ComfyWings::App.config.AMADEUS_KEY
AMADEUS_SECRET = ComfyWings::App.config.AMADEUS_SECRET

CORRECT = YAML.safe_load(File.read('spec/fixtures/flight_results.yml'))
CORRECT_TRIP = CORRECT['flights'][0]
CORRECT_AIRPORT = YAML.safe_load(File.read('spec/fixtures/airport_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'amadeus_api'
