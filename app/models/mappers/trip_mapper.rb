# frozen_string_literal: false

require_relative 'flight_mapper'

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
        DataMapper.new(data, from, to).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, from, to)
          @data = data
          @from = from
          @to = to
          @flight_mapper = FlightMapper.new
        end

        def build_entity
          ComfyWings::Entity::Trip.new(
            origin:,
            destination:,
            duration:,
            price:,
            type:,
            flights:
          )
        end

        def origin
          @from
        end

        def destination
          @to
        end

        def duration
          @data['itineraries'][0]['duration']
        end

        def price
          @data['price']['total']
        end

        def type
          @data['git_url']
        end

        def flights
          @flight_mapper.load_several(@data['itineraries'][0]['segments'])
        end
      end
    end
  end
end
