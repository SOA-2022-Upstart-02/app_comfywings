# frozen_string_literal: false

module ComfyWings
  module Amadeus
    # Data Mapper: Amadeus Flight-offer Segments -> Flight entity
    class FlightMapper
      def load_several(datas)
        datas.map do |data|
          FlightMapper.build_entity(data)
        end
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          ComfyWings::Entity::Flight.new(
            id: nil,
            origin:,
            destination:,
            duration:
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
      end
    end
  end
end
