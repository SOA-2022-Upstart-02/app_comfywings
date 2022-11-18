# frozen_string_literal: true

require_relative 'currencies'
require_relative 'flights'

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
          # TODO implement
        end
  
        def self.create(entity)
          raise 'Trip already exists' if find(entity)

          db_trip = Database::TripOrm.create(entity.to_attr_hash)

          currency = Currencies.db_find(entity.currency)
          db_trip.update(currency:)
          
          entity.flights.each do |flight|
            new_flight = Flights.create(flight, db_trip)
            db_trip.add_flight(new_flight)
          end

          rebuild_entity(db_trip)
        end
  
        def self.rebuild_entity(db_record)
          return nil unless db_record
  
          Entity::Trip.new(
            db_record.to_hash.merge(
              currency: Currencies.rebuild_entity(db_record.currency),
              flights: Flights.rebuild_many(db_record.flights)
            )
          )
        end
  
        def self.rebuild_many(db_records)
          db_records.map do |db_member|
            Trip.rebuild_entity(db_member)
          end
        end

        def self.db_find_id(id)
          Database::TripOrm.find(id)
        end
      end
    end
  end
  