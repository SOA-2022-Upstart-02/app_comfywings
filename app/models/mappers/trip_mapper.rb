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

      def search(from, to, from_date, to_date)
        datas = @gateway.trip_data(from, to, from_date, to_date)
        datas.map do |data|
          TripMapper.build_entity(data, from, to)
        end
      end

      def self.build_entity(data, from, to)
        TripDataMapper.new(data, from, to).build_entity
      end

      # Extracts entity specific elements from data structure
      class TripDataMapper
        def initialize(data, from, to)
          @data = data
          @from = from
          @to = to
          @flight_mapper = FlightMapper.new
        end

        def build_entity
          ComfyWings::Entity::Trip.new(
            id: nil,
            query_id: 1,
            currency:,
            origin:,
            destination:,
            outbound_duration:,
            inbound_duration:,
            price:,
            is_one_way:,      
            flights:, 
          )
        end

        def currency
          currency_code = @data['price']['currency']
          ComfyWings::Repository::For.klass(ComfyWings::Entity::Currency).find_code(currency_code)
        end

        def origin
          @from
        end

        def destination
          @to
        end

        def outbound_duration
          @data['itineraries'][0]['duration']
          #Time.parse(@data['itineraries'][0]['segments'][0]['departure']['at'])
        end

        def inbound_duration
          @data['itineraries'][1]['duration']
        end

        def price
          BigDecimal(@data['price']['total'])
        end

        def is_one_way
          @data['oneWay']
        end

        def flights
          outbound_flights = @flight_mapper.load_several(@data['itineraries'][0]['segments'], @data['travelerPricings'][0]['fareDetailsBySegment'], false)
          inbound_flights = @flight_mapper.load_several(@data['itineraries'][1]['segments'], @data['travelerPricings'][0]['fareDetailsBySegment'], true)
          outbound_flights + inbound_flights
        end
      end
    end
  end
end
