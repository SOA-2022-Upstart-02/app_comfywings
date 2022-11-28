# frozen_string_literal: true

require_relative 'currencies'
require_relative 'flights'
require_relative 'airports'

module ComfyWings
  module Repository
    # Repository for Trips
    class Trips
      def self.find(entity)
        find_id(entity.id)
      end

      def self.find_id(id)
        rebuild_entity Database::TripOrm.first(id:)
      end

      def self.find_query_id(query_id)
        rebuild_many Database::TripOrm.where(query_id:).all
      end

      # deliberately :reek:TooManyStatements calling method self.update
      def self.update(entity, db_trip)
        currency = Currencies.db_find(entity.currency)
        origin = Airports.db_find(entity.origin)
        destination = Airports.db_find(entity.destination)

        db_trip.update(currency:)
        db_trip.update(origin:)
        db_trip.update(destination:)
      end

      # deliberately :reek:TooManyStatements calling method self.create
      def self.create(entity)
        raise 'Trip already exists' if find(entity)

        db_trip = Database::TripOrm.create(entity.to_attr_hash)

        update(entity, db_trip)

        entity.flights.each do |flight|
          new_flight = Flights.create(flight, db_trip)
          db_trip.add_flight(new_flight)
        end

        rebuild_entity(db_trip)
      end

      def self.create_many(entities)
        entities.map do |entity|
          Trips.create(entity)
        end
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Trip.new(
          db_record.to_hash.merge(
            origin: Airports.rebuild_entity(db_record.origin),
            destination: Airports.rebuild_entity(db_record.destination),
            currency: Currencies.rebuild_entity(db_record.currency),
            flights: Flights.rebuild_many(db_record.flights)
          )
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          Trips.rebuild_entity(db_member)
        end
      end

      def self.db_find_id(id)
        Database::TripOrm.find(id)
      end
    end
  end
end
