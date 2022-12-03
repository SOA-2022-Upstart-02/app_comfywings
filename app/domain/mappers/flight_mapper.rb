# frozen_string_literal: false

module ComfyWings
  module Amadeus
    # Data Mapper: Amadeus Flight-offer Segments -> Flight entity
    class FlightMapper
      def load_several(flight_datas, fare_details, aircraft_list, is_return)
        flight_datas.map do |flight_data|
          FlightMapper.build_entity(flight_data, fare_details, aircraft_list, is_return)
        end
      end

      def self.build_entity(flight_data, fare_details, aircraft_list, is_return)
        DataMapper.new(flight_data, fare_details, aircraft_list, is_return).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(flight_data, fare_details, aircraft_list, is_return)
          @flight_data = flight_data
          @fare_details = fare_details
          @aircraft_list = aircraft_list
          @is_return = is_return
        end

        def build_entity # rubocop:disable Metrics/MethodLength
          ComfyWings::Entity::Flight.new(
            id: nil,
            trip_id: nil,
            origin:,
            destination:,
            duration:,
            aircraft:,
            number:,
            departure_time:,
            arrival_time:,
            cabin_class:,
            is_return: return?
          )
        end

        private

        def origin
          iata_code = @flight_data['departure']['iataCode']
          ComfyWings::Repository::For.klass(ComfyWings::Entity::Airport).find_code(iata_code)
        end

        def destination
          iata_code = @flight_data['arrival']['iataCode']
          ComfyWings::Repository::For.klass(ComfyWings::Entity::Airport).find_code(iata_code)
        end

        def duration
          @flight_data['duration']
        end

        def aircraft
          aircraft_code = @flight_data['aircraft']['code']
          @aircraft_list[aircraft_code]
        end

        def number
          "#{@flight_data['carrierCode']}-#{@flight_data['number']}"
        end

        def departure_time
          Time.parse(@flight_data['departure']['at'])
        end

        def arrival_time
          Time.parse(@flight_data['arrival']['at'])
        end

        def cabin_class
          id = @flight_data['id']
          detail = @fare_details.select { |fare_detail| fare_detail['segmentId'] == id }.first
          detail['cabin']
        end

        def return?
          @is_return
        end
      end
    end
  end
end
