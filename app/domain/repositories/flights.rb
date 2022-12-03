# frozen_string_literal: true

require_relative 'trips'

module ComfyWings
  module Repository
    # Repository for Flights
    class Flights
      def self.find(entity)
        find_id(entity.id)
      end

      def self.find_id(id)
        rebuild_entity Database::FlightOrm.first(id:)
      end

      def self.create(entity, trip)
        raise 'Query already exists' if find(entity)

        db_flight = Database::FlightOrm.create(entity.to_attr_hash)

        origin = Airports.db_find(entity.origin)
        destination = Airports.db_find(entity.destination)

        db_flight.update(trip:)
        db_flight.update(origin:)
        db_flight.update(destination:)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Flight.new(
          db_record.to_hash.merge(
            origin: Airports.rebuild_entity(db_record.origin),
            destination: Airports.rebuild_entity(db_record.destination)
          )
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          Flights.rebuild_entity(db_member)
        end
      end
    end
  end
end
