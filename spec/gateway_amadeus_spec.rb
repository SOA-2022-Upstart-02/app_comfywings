# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'

CORRECT_TRIP = CORRECT['flights'][0]

describe 'Tests AMADEUS API library' do
  VcrHelper.setup_vcr

  before do
    # Check request body as token and secret are not included in headers
    VcrHelper.configure_vcr_for_amadeus
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Trip information' do
    it 'HAPPY: should provide correct trip attributes' do
      trips = ComfyWings::Amadeus::TripMapper.new(AMADEUS_KEY, AMADEUS_SECRET)
        .search('TPE', 'MAD', '2022-11-21', '2022-11-28')
      trip = trips[0]
      _(trips.size).must_equal CORRECT['flight_num']

      #_(trip.currency.code).must_equal 'USD'
      _(trip.origin).must_equal 'TPE'
      _(trip.destination).must_equal 'MAD'
      _(trip.inbound_duration).must_equal 'PT41H15M'
      _(trip.outbound_duration).must_equal 'PT28H25M'
      _(trip.price).must_equal BigDecimal('906.60'),
      #_(trip.one_way?).must_equal false
      
      outbound_flight = trip.outbound_flights[0]      
      _(outbound_flight.origin).must_equal 'TPE'
      _(outbound_flight.destination).must_equal 'BKK'
      _(outbound_flight.duration).must_equal 'PT3H55M'
      _(outbound_flight.aircraft).must_equal '77W' #'BOEING 777-300ER'
      _(outbound_flight.number).must_equal 'LH-9729'
      _(outbound_flight.departure_time).must_equal Time.parse('2022-11-21T13:55:00')
      _(outbound_flight.arrival_time).must_equal Time.parse('2022-11-21T16:50:00')
      _(outbound_flight.cabin_class).must_equal 'ECONOMY'
      #_(inbound_flight.is_return).must_equal false

      inbound_flight = trip.inbound_flights[0]      
      _(inbound_flight.origin).must_equal 'MAD'
      _(inbound_flight.destination).must_equal 'MUC'
      _(inbound_flight.duration).must_equal 'PT2H40M'
      _(inbound_flight.aircraft).must_equal '319' #'AIRBUS A319'
      _(inbound_flight.number).must_equal 'LH-7039'
      _(inbound_flight.departure_time).must_equal Time.parse('2022-11-28T20:00:00')
      _(inbound_flight.arrival_time).must_equal Time.parse('2022-11-28T22:40:00')
      _(inbound_flight.cabin_class).must_equal 'ECONOMY'
      #_(outbound_flight.is_return).must_equal true
    end
  end

  describe 'Token generator' do
    before do
      @token = AuthToken.new
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

    it 'Bad: Should raise exception incorrect data' do
      _(proc do
        ComfyWings::Amadeus::Api
        .new(AMADEUS_KEY, AMADEUS_SECRET).airport_data('XYZ')
      end).must_raise ComfyWings::Amadeus::Api::Response::BadRequest
    end

    it 'Bad: Should raise exception when data is longer than 3 charactaers' do
      _(proc do
          ComfyWings::Amadeus::Api
          .new(AMADEUS_KEY, AMADEUS_SECRET).airport_data('Invalid_Length')
        end).must_raise ComfyWings::Amadeus::Api::Response::BadRequest
    end
  end
end
