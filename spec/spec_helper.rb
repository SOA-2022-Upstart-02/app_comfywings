# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'

require_relative '../lib/amadeus_api'

# TODO: add/move required libraries, constants, and files required for tests
#       when you write or create a new test
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
ANADEUS_TOKEN = CONFIG['AMADEUS_KEY']
ANADEUS_SECRET = CONFIG['AMADEUS_SECRET']

CORRECT = YAML.safe_load(File.read('spec/fixtures/flight_results.yml'))
