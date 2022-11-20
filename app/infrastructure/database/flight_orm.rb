# frozen_string_literal: true

require 'sequel'

module ComfyWings
  module Database
    # Object-Relational Mapper for TripQuery
    class FlightOrm < Sequel::Model(:flights)
      many_to_one :trip,
                  class: :'ComfyWings::Database::TripOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
