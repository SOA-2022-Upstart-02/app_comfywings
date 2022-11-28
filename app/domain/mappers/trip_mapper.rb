# frozen_string_literal: false

# require_relative 'flight_mapper'

module ComfyWings
  module Amadeus
    # Data Mapper: Amadeus Flight-offer -> Trip entity
    class TripMapper
      def initialize(key, secret, gateway_class = ComfyWings::Amadeus::Api)
        @key = key
        @secret = secret
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@key, @secret)
      end

      # TODO: change args to TripQuery
      def search(trip_query)
        trip_data = @gateway.trip_data(trip_query)
        aircraft_data = trip_data['dictionaries']['aircraft']
        trip_data['data'].map do |data|
          TripMapper.build_entity(data, aircraft_data, trip_query)
        end
      end

      def self.build_entity(data, aircraft_data, trip_query)
        TripDataMapper.new(data, aircraft_data, trip_query).build_entity
      end

      # Extracts entity specific elements from data structure
      class TripDataMapper
        def initialize(data, aircraft_data, trip_query)
          @data = data
          @aircraft_data = aircraft_data
          @trip_query = trip_query
          @flight_mapper = FlightMapper.new
        end

        def build_entity # rubocop:disable Metrics/MethodLength
          ComfyWings::Entity::Trip.new(
            id: nil,
            query_id:,
            currency:,
            origin:,
            destination:,
            outbound_duration:,
            inbound_duration:,
            price:,
            is_one_way: one_way?,
            flights:
          )
        end

        def currency
          currency_code = @data['price']['currency']
          ComfyWings::Repository::For.klass(ComfyWings::Entity::Currency).find_code(currency_code)
        end

        def query_id
          @trip_query.id
        end

        def origin
          iata_code = @trip_query.origin
          ComfyWings::Repository::For.klass(ComfyWings::Entity::Airport).find_code(iata_code)
        end

        def destination
          iata_code = @trip_query.destination
          ComfyWings::Repository::For.klass(ComfyWings::Entity::Airport).find_code(iata_code)
        end

        def outbound_duration
          @data['itineraries'][0]['duration']
        end

        def inbound_duration
          one_way? ? '' : @data['itineraries'][1]['duration']
        end

        def price
          BigDecimal(@data['price']['total'])
        end

        def one_way?
          @trip_query.is_one_way
        end

        def flights
          outbound_flights = map_flights(false)
          inbound_flights = one_way? ? [] : map_flights(true)
          outbound_flights + inbound_flights
        end

        def map_flights(is_return)
          type = is_return ? 1 : 0
          @flight_mapper.load_several(
            @data['itineraries'][type]['segments'],
            @data['travelerPricings'][0]['fareDetailsBySegment'],
            @aircraft_data, is_return
          )
        end
      end
    end
  end
end
