# frozen_string_literal: true

module ComfyWings
  module Database
    # object-relational mapper for airport
    class AirportOrm < Sequel::Model(:airports)
      one_to_many :trip,
                  class: :'ComfyWings::Database::TripOrm',
                  key: '%i[origin_id, destination_id]'
      one_to_many :flight,
                  class: :'ComfyWings::Database::FlightOrm',
                  key: '%i[origin_id, destination_id]'

      def self.find(airport_info)
        first(iata_code: airport_info[:iata_code])
      end
    end
  end
end
