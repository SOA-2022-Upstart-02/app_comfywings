# frozen_string_literal: true

module Amadeus
  # Model for Flight
  class Flight
    def initialize(flight_data)
      @flight = flight_data
    end

    def seats_num
      @flight['numberOfBookableSeats']
    end

    def outbound_duration
      @flight['itineraries'][0]['duration']
    end

    def inbound_duration
      @flight['itineraries'][1]['duration']
    end

    def total_price
      @flight['price']['total']
    end
  end
end
