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
            query_id: 1,
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
          1 # TODO: get query_id from search condition
        end

        def origin
          @trip_query.origin
        end

        def destination
          @trip_query.destination
        end

        def outbound_duration
          @data['itineraries'][0]['duration']
          # Time.parse(@data['itineraries'][0]['segments'][0]['departure']['at'])
        end

        def inbound_duration
          @data['itineraries'][1]['duration']
        end

        def price
          BigDecimal(@data['price']['total'])
        end

        def one_way?
          @data['oneWay']
        end

        def flights
          outbound_flights = map_flights(false)
          inbound_flights = map_flights(true)
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
