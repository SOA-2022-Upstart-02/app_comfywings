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
      trip_query = ComfyWings::Amadeus::TripMapper.new(AMADEUS_KEY, AMADEUS_SECRET)
        .search('TPE', 'MAD', '2022-11-21', '2022-11-28')

      rebuilt = ComfyWings::Repository::For.entity(trip_query[0]).rebuild_entity(trip_query[0])

      _(rebuilt.origin).must_equal(trip_query[0].origin)
      _(rebuilt.destination).must_equal(trip_query[0].destination)
    end
  end
end
