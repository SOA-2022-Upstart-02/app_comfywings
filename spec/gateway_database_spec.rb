# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'
require 'securerandom'

describe 'Integration Tests of AMADEUS API and Database' do
  VcrHelper.setup_vcr

  before do
    # Check request body as token and secret are not included in headers
    VcrHelper.configure_vcr_for_amadeus
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve Currency By Currency Code' do
    it 'HAPPY: should be able to save currencies to database' do
      currency = ComfyWings::Repository::For.klass(ComfyWings::Entity::Currency).find_code('TWD')

      _(currency.code).must_equal('TWD')
      _(currency.name).must_equal('Taiwan Dollar')
    end

    it 'HAPPY: there should be 4 currencies: TWD USD EUR' do
      reposit = ComfyWings::Repository::For.klass(ComfyWings::Entity::Currency)
      currencies = reposit.all
      _(currencies.size).must_equal(4)
    end

    it 'HAPPY: should be able to save tripQuery from amadeus to TripQuery table in database' do
      #trip_query = ComfyWings::Amadeus::TripMapper.new(AMADEUS_KEY, AMADEUS_SECRET)
       # .search('TPE', 'MAD', '2022-11-21', '2022-11-28')

       #query_rebuilt = ComfyWings::Repository::For.entity(trip_query[0]).create(trip_query[0])

       #_(query_rebuilt.origin).must_equal(trip_query[0].origin)
       #_(query_rebuilt.destination).must_equal(trip_query[0].destination)
       #_(query_rebuilt.departure_date).must_equal(trip_query[0].departure_date)
       #_(query_rebuilt.arrival_date).must_equal(trip_query[0].arrival_date)
       #_(query_rebuilt.is_one_way).must_equal(trip_query[0].is_one_way)
    end
  end
end
