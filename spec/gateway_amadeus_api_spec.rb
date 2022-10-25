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
      matched_flights = ComfyWings::Amadeus::Api.new(AMADEUS_KEY, AMADEUS_SECRET)
                                           .flight('TPE', 'MAD', '2022-11-01', '2022-11-05')
      _(matched_flights.size).must_equal CORRECT['flight_num']
    end

    it 'SAD: should raise exception on incorrect flight information' do
      _(proc do
          ComfyWings::Amadeus::Api.new('BAD_TOKEN', 'BAD_SECRET')
                             .flight('AIRPORT_NOT_EXIST', 'AIRPORT_NOT_EXIST', '2022-11-01', '2022-11-05')
        end).must_raise ComfyWings::Amadeus::Api::Response::Unauthorized
    end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        ComfyWings::Amadeus::Api.new('BAD_TOKEN', 'BAD_SECRET')
                           .flight('TPE', 'MAD', '2022-11-01', '2022-11-05')
      end).must_raise ComfyWings::Amadeus::Api::Response::Unauthorized
    end
  end

  describe 'Flight information' do
    before do
      @matched_flights = ComfyWings::Amadeus::Api.new(AMADEUS_KEY, AMADEUS_SECRET)
                                            .flight('TPE', 'MAD', '2022-11-01', '2022-11-05')
    end

    it 'HAPPY: should recognize flight' do
      _(@matched_flights.flights[0]).must_be_kind_of ComfyWings::Amadeus::Flight
    end

    it 'HAPPY: should identify flight' do
      _(@matched_flights.flights[0].total_price).must_equal CORRECT['flights'][0]['total_price']
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
end
