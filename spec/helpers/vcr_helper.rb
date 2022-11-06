# frozen_string_literal: true

require 'vcr'
require 'webmock'

module VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  AMADEUS_CASSETTE = 'amadeus_api'

  def self.setup_vcr
    VCR.configure do |c|
      c.cassette_library_dir = CASSETTES_FOLDER
      c.hook_into :webmock
    end
  end

  def self.configure_vcr_for_amadeus
    VCR.configure do |c|
      c.filter_sensitive_data('<AMADEUS_KEY>') { AMADEUS_KEY }
      c.filter_sensitive_data('<AMADEUS_KEY_ESC>') { CGI.escape(AMADEUS_KEY) }
  
      c.filter_sensitive_data('<AMADEUS_SECRET>') { AMADEUS_SECRET }
      c.filter_sensitive_data('<AMADEUS_SECRET_ESC>') { CGI.escape(AMADEUS_SECRET) }
    end

    VCR.insert_cassette(
      AMADEUS_CASSETTE,
      record: :new_episodes,
      match_requests_on: %i[method uri body headers]
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end