# frozen_string_literal: true

require 'sequel'

module ComfyWings
  module Database
    # Object-Relational Mapper for TripQuery
    class TripOrm < Sequel::Model(:trips)
      one_to_many :flights,
                  class: :'ComfyWings::Database::FlightOrm',
                  key: :trip_id
      many_to_one :currency,
                  class: :'ComfyWings::Database::CurrencyOrm'

      plugin :timestamps, update_on_create: true

      def self.find(id)
        first(id: id)
      end
    end
  end
end
