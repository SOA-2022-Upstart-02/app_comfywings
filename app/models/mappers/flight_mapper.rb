# frozen_string_literal: false

module ComfyWings
  module Amadeus
    # Data Mapper: Amadeus Flight-offer Segments -> Flight entity
    class FlightMapper
      def load_several(datas, fareDetails, is_return)
        datas.map do |data|
          FlightMapper.build_entity(data, fareDetails, is_return)
        end
      end

      def self.build_entity(data, fareDetails, is_return)
        DataMapper.new(data, fareDetails, is_return).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, fareDetails, is_return)
          @data = data
          @fareDetails = fareDetails
          @is_return = is_return
        end

        def build_entity
          ComfyWings::Entity::Flight.new(
            id: nil,
            trip_id: 2,
            origin:,
            destination:,
            duration:,
            aircraft:,
            number:,
            departure_time:,
            arrival_time:,
            cabin_class:,
            is_return: return?,
          )
        end

        private

        def origin
          @data['departure']['iataCode']
        end

        def destination
          @data['arrival']['iataCode']
        end

        def duration
          @data['duration']
        end

        def aircraft
          @data['aircraft']['code']
        end

        def number
          "#{@data['carrierCode']}-#{@data['number']}"
        end

        def departure_time
          Time.parse(@data['departure']['at'])
        end

        def arrival_time
          Time.parse(@data['arrival']['at'])
        end

        def cabin_class
          id = @data['id']         
          detail = @fareDetails.select { |fareDetail| fareDetail['segmentId'] == id }.first
          detail['cabin']
        end

        def return?
          @is_return
        end
      end
    end
  end
end
