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

    it 'HAPPY: should be able to save trip query from amadeus to Currency table in database' do
      currency_query = ComfyWings::Amadeus::CurrencyMapper.new(AMADEUS_KEY, AMADEUS_SECRET)
        .search('TPE', 'MAD', '2022-11-21', '2022-11-28')

      currency_rebuilt = ComfyWings::Repository::For.entity(currency_query).create(currency_query)

      _(currency_rebuilt.code).must_equal(currency_query.code)
      _(currency_rebuilt.name).must_equal(currency_query.name)
    end

  end
    it 'HAPPY: should be able to save trip query from amadeus to TripQuery table in database' do
      trip_query = ComfyWings::Amadeus::TripMapper.new(AMADEUS_KEY, AMADEUS_SECRET)
        .search('TPE', 'MAD', '2022-11-21', '2022-11-28')

      query_rebuilt = ComfyWings::Repository::For.entity(trip_query[0]).create(trip_query[0])

      _(query_rebuilt.origin).must_equal(trip_query[0].origin)
      _(query_rebuilt.destination).must_equal(trip_query[0].destination)
      _(query_rebuilt.departure_date).must_equal(trip_query[0].departure_date)
      _(query_rebuilt.arrival_date).must_equal(trip_query[0].arrival_date)
      _(query_rebuilt.is_one_way).must_equal(trip_query[0].is_one_way)
    end
end


