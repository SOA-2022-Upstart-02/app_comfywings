# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'
require 'securerandom'
require "active_support"
require 'active_support/core_ext/date/calculations'

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
      _(currency.name).must_equal('New Taiwan dollar')
    end

    it 'HAPPY: there should be 4 currencies: TWD USD EUR GBP' do
      reposit = ComfyWings::Repository::For.klass(ComfyWings::Entity::Currency)
      currencies = reposit.all
      _(currencies.size).must_equal(4)
    end

    it 'HAPPY: should be able to save tripQuery from amadeus to TripQuery table in database' do
      # trip_query = ComfyWings::Amadeus::TripMapper.new(AMADEUS_KEY, AMADEUS_SECRET)
      # .search('TPE', 'MAD', '2022-11-21', '2022-11-28')

      # query_rebuilt = ComfyWings::Repository::For.entity(trip_query[0]).create(trip_query[0])

      # _(query_rebuilt.origin).must_equal(trip_query[0].origin)
      # _(query_rebuilt.destination).must_equal(trip_query[0].destination)
      # _(query_rebuilt.departure_date).must_equal(trip_query[0].departure_date)
      # _(query_rebuilt.arrival_date).must_equal(trip_query[0].arrival_date)
      # _(query_rebuilt.is_one_way).must_equal(trip_query[0].is_one_way)
    end
  end

  describe 'Test TripQuery Repository' do
    it 'Test Save new TripQuery and find TripQuery code' do
      code = SecureRandom.uuid
      currency = ComfyWings::Repository::For.klass(ComfyWings::Entity::Currency).find_code('TWD')

      trip_query = ComfyWings::Entity::TripQuery.new(
        id: nil,
        code:,
        currency:,
        origin: 'TPE',
        destination: 'MAD',
        departure_date: Date.parse('2001-02-03'),
        arrival_date: Date.parse('2001-03-03'),
        adult_qty: 1,
        children_qty: 1,
        is_one_way: true
      )

      repository = ComfyWings::Repository::For.klass(ComfyWings::Entity::TripQuery)

      repository.create(trip_query)
      trip_query = repository.find_code(code)
      _(trip_query.origin).must_equal('TPE')
      _(trip_query.currency.name).must_equal('New Taiwan dollar')
    end
  end

  describe 'Test Flight Repository' do
    it '' do
      flight = ComfyWings::Entity::Flight.new(
        id: nil,
        trip_id: 1,
        origin: 'TPE',
        destination: 'MAD',
        duration: 'PT1H10M',         
        aircraft: 'BOEING 737-800',       
        number: 'G3-1093',         
        departure_time: Time.parse('2001-02-03'),
        arrival_time: Time.parse('2001-02-03'),
        cabin_class: 'economy',
        is_return: true
      )

      currency = ComfyWings::Repository::For.klass(ComfyWings::Entity::Currency).find_code('TWD')
      flights = []
      flights.push(flight)

      trip = ComfyWings::Entity::Trip.new(
        id: nil,
        query_id: 1,
        currency: currency,
        origin: 'TPE',
        destination: 'MAD',
        departure_time: Time.parse('2001-02-03'),
        arrival_time: Time.parse('2001-02-03'),
        inbound_duration: 'PT1H10M',
        outbound_duration: 'PT2H20M',
        price: BigDecimal('1234.56'),
        is_one_way: false,      
        flights: flights,         
      )      

      repository = ComfyWings::Repository::For.klass(ComfyWings::Entity::Trip)
      new_trip = repository.create(trip)    
    end
  end
end
