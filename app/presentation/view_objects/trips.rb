# frozen_string_literal: true

module Views
    #class for flight infomation
    class Flight
      def initialize(flight)
        @flight = flight
      end
  
      def origin
        @flight.origin
      end
  
      def destination
        @flight.destination
      end
  
      def departure_time
        @flight.departure_time
      end
  
      def arrival_date
        @flight.arrival_data
      end
  
      def flight
        @flight.duration
      end
    end
  end