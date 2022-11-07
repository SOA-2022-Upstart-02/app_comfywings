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

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
AMADEUS_KEY = CONFIG['AMADEUS_KEY']
AMADEUS_SECRET = CONFIG['AMADEUS_SECRET']

CORRECT = YAML.safe_load(File.read('spec/fixtures/flight_results.yml'))
CORRECT_TRIP = CORRECT['flights'][0]
CORRECT_AIRPORT = YAML.safe_load(File.read('spec/fixtures/airport_results.yml'))
