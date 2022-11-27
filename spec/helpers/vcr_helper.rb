# frozen_string_literal: true

require 'vcr'
require 'webmock'

# vcr helper module
module VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  AMADEUS_CASSETTE = 'amadeus_api'

  def self.setup_vcr
    VCR.configure do |vcr_config|
      vcr_config.cassette_library_dir = CASSETTES_FOLDER
      vcr_config.hook_into :webmock
    end
  end

  def self.vcr_insert
    VCR.insert_cassette(
      AMADEUS_CASSETTE,
      record: :new_episodes, match_requests_on: %i[method uri body headers]
    )
  end

  # deliberately :reek:TooManyStatements calling method configure_vcr_for_amadeus
  def self.configure_vcr_for_amadeus
    VCR.configure do |config|
      config.filter_sensitive_data('<AMADEUS_KEY>') { AMADEUS_KEY }
      config.filter_sensitive_data('<AMADEUS_KEY_ESC>') { CGI.escape(AMADEUS_KEY) }
      config.filter_sensitive_data('<AMADEUS_SECRET>') { AMADEUS_SECRET }
      config.filter_sensitive_data('<AMADEUS_SECRET_ESC>') { CGI.escape(AMADEUS_SECRET) }
    end
    vcr_insert
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
