# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../lib/amadeus_api'
require_relative '../lib/flight_info'

# TODO: add/move required libraries, constants, and files required for tests
#       when you write or create a new test
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
AMADEUS_TOKEN = CONFIG['AMADEUS_KEY']
AMADEUS_SECRET = CONFIG['AMADEUS_SECRET']
CORRECT = YAML.safe_load(File.read('spec/fixtures/flight_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'amadeus_api'
