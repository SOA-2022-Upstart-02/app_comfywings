# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Tests AMADEUS API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<AMADEUS_KEY>') { AMADEUS_KEY }
    c.filter_sensitive_data('<AMADEUS_KEY_ESC>') { CGI.escape(AMADEUS_KEY) }

    c.filter_sensitive_data('<AMADEUS_SECRET>') { AMADEUS_SECRET }
    c.filter_sensitive_data('<AMADEUS_SECRET_ESC>') { CGI.escape(AMADEUS_SECRET) }
  end

  before do
    # Check request body as token and secret are not included in headers
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri body headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Flight information' do
    it 'HAPPY: should provide correct flight attributes' do
      trips = ComfyWings::Amadeus::TripMapper.new(AMADEUS_KEY, AMADEUS_SECRET)
                                             .search('TPE', 'MAD', '2022-11-01', '2022-11-05')
      trip = trips[0]
      _(trips.size).must_equal CORRECT['flight_num']
      _(trip.price).must_equal CORRECT['flight_num']
      _(trip.origin).must_equal CORRECT['flight_num']
    end
  end

  describe 'Token generator' do
    before do
      @token = AuthToken.new('config/secrets.yml')
    end
    it 'It should create a new auth token' do
      _(@token.obtain_token).wont_be_nil
    end
  end

  describe 'amadeus information' do
    before do
      @obtained_airports = ComfyWings::AirportMapper.new(AMADEUS_KEY, AMADEUS_SECRET)
    end

    it 'Happy: should provide correct attributes' do
      _(@obtained_airports.airport_size(DEPATURE)).must_equal CORRECT_AIRPORT['num_of_airport']
    end

    it 'Happy: should provide correct airport data' do
      _(@obtained_airports.airport_data(DEPATURE)[0]['type']).must_equal CORRECT_AIRPORT['airports'][0]['info_type']
      _(@obtained_airports.airport_data(DEPATURE)[0]['subtype']).must_equal CORRECT_AIRPORT['airports'][0]['area']
      _(@obtained_airports.airport_data(DEPATURE)[0]['name']).must_equal CORRECT_AIRPORT['airports'][0]['city_name']
      _(@obtained_airports.airport_data(DEPATURE)[0]['iataCode']).must_equal CORRECT_AIRPORT['airports'][0]['city_code']
    end
  end

  describe 'Error responses' do
    it 'Bad: should raise exception when unauthorised' do
      _(proc do
        ComfyWings::Amadeus::Api
          .new('BAD_TOKEN', 'BAD_SECRET').airport_data(DEPATURE)
      end).must_raise ComfyWings::Amadeus::Api::Response::Unauthorized
    end

    # it 'Bad: Should raise exception incorrect data' do
    #   _(proc do
    #     ComfyWings::Amadeus::Api
    #       .new(AMADEUS_KEY, AMADEUS_SECRET).airport_data('LSK')
    #   end).must_raise ComfyWings::Amadeus::Api::Response::Unauthorized
    # end
  end
end
