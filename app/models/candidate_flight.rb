# frozen_string_literal: true

require_relative 'flight'

module ComfyWings
  module Amadeus
    # Model for Flight
    class CandidateFlight
      def initialize(flight_data)
        @flight_info = flight_data
      end

      def size
        @flight_info['meta']['count']
      end

      def flights
        @flights ||= @flight_info['data'].map do |flight|
          Flight.new(flight)
        end
      end
    end
  end
end
