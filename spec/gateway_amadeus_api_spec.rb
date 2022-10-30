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
      matched_flights = ComfyWings::Amadeus::TripMapper.new(AMADEUS_KEY, AMADEUS_SECRET)
                                                       .search('TPE', 'MAD', '2022-11-01', '2022-11-05')
      _(matched_flights.size).must_equal CORRECT['flight_num']
    end
  end
end
