# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of Amadeus API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_amadeus
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
        DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save project from Github to database' do
        trip_query = ComfyWings::Amadeus::TripMapper.new(AMADEUS_KEY, AMADEUS_SECRET).search('TPE', 'MAD', '2022-11-01', '2022-11-05')

        rebuilt = ComfyWings::Repository::For.entity(trip_query).rebuild_entity(trip_query)
    end
  end
end