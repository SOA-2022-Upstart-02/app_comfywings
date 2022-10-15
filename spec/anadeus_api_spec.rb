# frozen_string_literal: true

require 'minitest/autorun'
require 'yaml'
require_relative '../lib/amadeus_api'

CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
ANADEUS_TOKEN = CONFIG['AMADEUS_KEY']
ANADEUS_SECRET = CONFIG['AMADEUS_SECRET']
CORRECT = YAML.safe_load(File.read('spec/fixtures/flight_results.yml'))

describe 'Tests ANADEUS API library' do
  describe 'Flight information' do
    it 'HAPPY: should provide correct project attributes' do
      matched_flights = Amadeus::AmadeusApi.new(ANADEUS_TOKEN, ANADEUS_SECRET)
                                           .flight('TPE', 'MAD', '2022-11-01', '2022-11-05')
      _(matched_flights.size).must_equal CORRECT['flight_num']
    end

    it 'SAD: should raise exception on incorrect project' do
      _(proc do
          Amadeus::AmadeusApi.new('BAD_TOKEN', 'BAD_SECRET')
                             .flight('AIRPORT_NOT_EXIST', 'AIRPORT_NOT_EXIST', '2022-11-01', '2022-11-05')
        end).must_raise Amadeus::AmadeusApi::Errors::Unauthorized
    end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        Amadeus::AmadeusApi.new('BAD_TOKEN', 'BAD_SECRET')
                           .flight('TPE', 'MAD', '2022-11-01', '2022-11-05')
      end).must_raise Amadeus::AmadeusApi::Errors::Unauthorized
    end
  end

  describe 'Flight information' do
    before do
      @matched_flights = Amadeus::AmadeusApi.new(ANADEUS_TOKEN, ANADEUS_SECRET)
                                            .flight('TPE', 'MAD', '2022-11-01', '2022-11-05')
    end

    it 'HAPPY: should recognize flight' do
      _(@matched_flights.flights[0]).must_be_kind_of Amadeus::Flight
    end

    it 'HAPPY: should identify flight' do
      _(@matched_flights.flights[0].total_price).must_equal CORRECT['flights'][0]['total_price']
    end
  end
end
