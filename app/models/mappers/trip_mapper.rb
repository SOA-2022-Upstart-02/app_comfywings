# frozen_string_literal: false

#require_relative 'flight_mapper'

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
        end

        def build_entity
          ComfyWings::Entity::Trip.new(
            id: nil,
            origin:,
            destination:,
            departure_date:,
            arrival_date:,
            is_one_way:

            #adult_qty:,
            #children_qty:

          )
        end

        def origin
          @from
        end

        def destination
          @to
        end

        def departure_date
          @data['itineraries'][0]['segments'][0]["departure"]["at"]
        end

        def arrival_date
          @data['itineraries'][0]['segments'][0]["arrival"]["at"]
        end

        def is_one_way
          @data['oneWay']
        end
      end
    end
  end
end
