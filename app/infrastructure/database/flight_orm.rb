# frozen_string_literal: true

require 'sequel'

module ComfyWings
  module Database
    # Object-Relational Mapper for TripQuery
    class FlightOrm < Sequel::Model(:flights)
      many_to_one :trip,
                  class: :'ComfyWings::Database::TripOrm'
      many_to_one :origin,
                  class: :'ComfyWings::Database::AirportOrm'
      many_to_one :destination,
                  class: :'ComfyWings::Database::AirportOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
